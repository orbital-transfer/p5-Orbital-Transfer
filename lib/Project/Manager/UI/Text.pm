package Project::Manager::UI::Text;

use Moo;
use autodie;
use FindBin;
use Capture::Tiny qw(capture_stdout);
use JSON::MaybeXS;
use Text::Table::Tiny qw(generate_table);
use Template;
use Template::Filters;
use Getopt::Long;
use URI;
use URI::QueryParam;
use Path::Tiny;
use Template::Extract;
use String::Strip;
use Hash::Merge;
use IPC::Run;
use List::UtilsBy qw( sort_by );
use Sort::Key::Natural qw(natkeysort);
use Cwd;

use Project::Manager::Repo::Git;
use Project::Manager::Platform::GitHub::Repo;

with qw(Project::Manager::UI::Role::DI);

has tt => ( is => 'lazy' );

sub _build_tt {
	my $tt = Template->new(
		INCLUDE_PATH => path($FindBin::Bin, qw(.. template)),
		INTERPOLATE => 1,
	);
}

sub run {
	my ($self, @args) = @_;
	my ($read, $write, $remind, $uri_str, $auto_uri);
	$read = 0;
	$write = 0;
	GetOptions(
		"uri=s", \$uri_str,
		"read", \$read,
		"write", \$write,
		"remind", \$remind,
		"auto-uri", \$auto_uri,
	);
	if( $read ) {
		my $opt = $self->opt_from_uri_str($uri_str);
		$self->output_issues( $opt );
	} elsif( $write ) {
		my $opt = $self->opt_from_uri_str($uri_str);
		$self->analyse_issues( $opt );
	} elsif( $remind ) {
		my $opt = $self->opt_from_uri_str($uri_str);
		$self->remind_cal_issues( $opt );
	} elsif( $auto_uri ) {
		print $self->get_uri_from_git_remote;
	} else {
		die "Need --read/--write/--auto-uri";
	}
}

sub get_uri_from_git_remote {
	my $cwd = cwd();
	my $git_repo = Project::Manager::Repo::Git->new( directory => $cwd );
	my $remote_fetch = $git_repo->remotes->{origin}{fetch} or return;
	my $github_repo = Project::Manager::Platform::GitHub::Repo->new( uri => $remote_fetch );
	return "pm://@{[ $github_repo->namespace ]}/@{[ $github_repo->name ]}";
}

sub opt_from_uri_str {
	my ($self, $uri_str) = @_;
	if( not $uri_str ) {
		$uri_str = $self->get_uri_from_git_remote;
	}
	die "Missing URI" unless $uri_str;
	my $uri = URI->new( $uri_str );
	my $refresh = $uri->query_param('refresh') // 0;
	my @sort_by = split(',', $uri->query_param('sort') // '' );
	my $opt = {
		repo => {
			namespace => $uri->authority,
			name => ($uri->path_segments)[1],
		},
		refresh => $refresh,
		sort_by => \@sort_by,
	};
	$opt->{repo_gh} = "@{[ $opt->{repo}{namespace} ]}/@{[ $opt->{repo}{name} ]}";

	$opt;
}

sub analyse_issues {
	my ($self, $opt) = @_;

	my $txt = join "", <STDIN>;
	my $template_src = $self->tt->context->insert('gh-issues-extract.tt2');
	my $extract = Template::Extract->new;

	my $val = $extract->extract( $template_src, $txt );
	my $issues = $val->{issues};
	StripLTSpace($val->{repo});
	my $dbm = $self->container->resolve( service => 'dbm');
	$dbm->begin_work;
	for my $issue (@$issues) {
		StripLTSpace( $issue->{number} );
		my $issue_uri = $self->get_issue_uri(
			$val->{repo},
			0 + $issue->{number} );
		for my $key (qw(date_span difficulty priority)) {
			StripLTSpace( $issue->{$key} );
			if( $issue->{$key} ) {
				$dbm->{$issue_uri}{$key} = $issue->{$key};
			} else {
				delete $dbm->{$issue_uri}{$key};
			}
		}
	}
	$dbm->commit;
	#use DDP; p $val;
}

sub get_issue_uri {
	my ($self, $repo, $id) = @_;
	my $gh_uri = "https://github.com/$repo/$id";
}

sub gather_issues {
	my ($self, $opt) = @_;

	my $repo = $opt->{repo_gh};
	my $expires_in = 'never';
	my $dbm = $self->container->resolve( service => 'dbm');

	$self->container->resolve( service => 'cache')->remove( $repo ) if $opt->{refresh};
	my $issues = $self->container->resolve( service => 'cache')->compute(
		$repo,
		$expires_in,
		sub { $self->issues( $repo ); }
	);

	for my $cur_issue ( @$issues ) {
		my $id = $cur_issue->{number};
		$self->container->resolve( service => 'cache')->remove( "$repo/issue/$id" ) if $opt->{refresh};
		$cur_issue->{info} = $self->container->resolve( service => 'cache')->compute(
			"$repo/issue/$id",
			$expires_in,
			sub { $self->issue_info( $repo, $id ); }
		);
		$cur_issue->{info}{body} =~ s/\r//sg;
		my $issue_uri = $self->get_issue_uri($repo, $id);
		if( $dbm->exists( $issue_uri ) ) {
			my $copy = $dbm->fetch( $issue_uri );
			while( my ($k, $v) = each %$copy ) {
				$cur_issue->{$k} = $v;
			}
		}
	}

	$issues;
}

sub output_issues {
	my ($self, $opt) = @_;

	my $repo = $opt->{repo_gh};
	my $issues = $self->gather_issues($opt);

	my $issue_to_date_span = {};
	for my $cur_issue ( @$issues ) {
		my $id = $cur_issue->{number};
		if( exists $cur_issue->{date_span} ) {
			$issue_to_date_span->{$id} = $cur_issue->{date_span};
		}
	}

	my $filled;
	my @sort_by = @{$opt->{sort_by}};
	my $extract_sort_by = sub {
		my $item = shift;
		map { $item->{$_} // 'inf' } @sort_by;
	};
	$issues = [ natkeysort { join ";", ( @sort_by ? $extract_sort_by->($_) : $_->{number} )  } @$issues ];
	my $calendar = $self->remind_cal( $issue_to_date_span );
	$self->tt->process( 'gh-issues.tt2',
		{ repo => "$repo", issues => $issues, calendar => $calendar }, \$filled)
		or die $self->tt->error;
	print $filled;
}

sub remind_cal_issues {
	my ($self, $opt) = @_;

	my $issues = $self->gather_issues($opt);

	my $remind_output = "";
	for my $cur_issue ( @$issues ) {
		my $id = $cur_issue->{number};
		if( exists $cur_issue->{date_span} ) {
			$remind_output .= "REM $cur_issue->{date_span} AT 06:00 DURATION 3:00 MSG $opt->{repo_gh}#$cur_issue->{number} $cur_issue->{title} <$cur_issue->{info}{html_url}> \n";
		}
	}

	print $remind_output;
}

sub issues {
	my ($self, $repo) = @_;
	my ($json_stdout, $exit) = capture_stdout {
		system(qw(git hub issues --json), $repo);
	};
	$json_stdout =~ s/\AIssues.*$//m; # get rid of first line
	decode_json( $json_stdout );
}

sub issue_info {
	my ($self, $repo, $id) = @_;
	my ($json_stdout, $exit) = capture_stdout {
		system(qw(git hub issue --json), $repo, $id);
	};
	# split into issue and comments
	my ($body, $comments) = $json_stdout =~ /\A(.*?)\n(?:Comments:\n(.*?))?\Z/ms;
	my $body_data = decode_json( $body );
	$body_data->{comments} = $comments ? decode_json( $comments ) : [];

	$body_data;
}

sub remind_cal {
	my ($self, $issue_to_date_span) = @_;
	my ($in, $out);
	while( my ($k, $v) = each %$issue_to_date_span ) {
		$in .= "REM $v {$k}\n";
	}
	IPC::Run::run([ qw( remind -c+6 -) ], \$in, \$out );
	$out;
}

1;
