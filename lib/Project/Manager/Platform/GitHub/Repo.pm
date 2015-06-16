package Project::Manager::Platform::GitHub::Repo;

use Modern::Perl;
use Moo;
use Project::Manager::Issue::GitHub;

with qw(Project::Manager::Platform::GitHub::PithubRole);

has uri => ( is => 'ro',
	trigger => 1,     # _trigger_uri
	builder => 1, lazy => 1 );   # _build_uri

has git_scp_uri => ( is => 'lazy' ); # _build_git_scp_uri

has github_https_web_uri => ( is => 'lazy' ); # _build_github_https_web_uri

has [ qw{namespace name} ] => ( is => 'rw' );

has pithub_data => ( is => 'lazy' ); # _build_pithub_data

sub _parse_uri {
	my ($self, $uri) = @_;
	if( $uri =~ m,
		        ^
		(?:
			  git\@github\.com:
			| git://github\.com/
			| https? :// github\.com/
		)
		(         [^/\s]+    )
		        /
		(         [^/\s]+    )
		        $,x ) {

		my $namespace = $1;
		my $name = $2;
		$name =~ s/.git$//;

		return ( $namespace, $name );
	} else {
		die "invalid GitHub URI: $uri";
	}
}

sub _trigger_uri {
	my ($self, $uri) = @_;
	my ($namespace, $name) = $self->_parse_uri($uri);
	$self->namespace( $namespace );
	$self->name( $name );
}

sub _build_uri {
	my ($self) = @_;
	return $self->git_scp_uri;
}
sub _build_git_scp_uri {
	my ($self) = @_;
	return "git\@github.com:@{[ $self->namespace ]}/@{[ $self->name ]}.git";
}
sub _build_github_https_web_uri {
	my ($self) = @_;
	return "https://github.com/@{[ $self->namespace ]}/@{[ $self->name ]}";
}
sub _build_pithub_data {
	my ($self) = @_;
	return $self->_pithub_client->repos->get( user => $self->namespace, repo => $self->name );
}

sub is_fork {
	my ($self) = @_;
	$self->pithub_data->first->{fork}
}

sub number_of_open_issues {
	my ($self) = @_;
	$self->pithub_data->first->{open_issues_count};
}

sub issues {
	my ($self) = @_;
	[ map {
		Project::Manager::Issue::GitHub->new( $_, repo => $self )
	} @{ $self->_pithub_client->issues->list(
			user => $self->namespace,
			repo => $self->name,
		)->content } ];
}

1;
