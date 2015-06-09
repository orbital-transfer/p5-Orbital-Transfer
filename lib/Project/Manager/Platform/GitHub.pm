package Project::Manager::Platform::GitHub;

use Modern::Perl;
use Moo;
use Pithub;

has uri => ( is => 'ro',
	trigger => 1,     # _trigger_uri
	builder => 1, lazy => 1 );   # _build_uri

has git_scp_uri => ( is => 'lazy' ); # _build_git_scp_uri

has github_https_web_uri => ( is => 'lazy' ); # _build_github_https_web_uri

has [ qw{namespace name} ] => ( is => 'rw' );

has _pithub_client => ( is => 'lazy' ); # _build__pithub_client
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
sub _build__pithub_client {
	Pithub->new;
}
sub _build_pithub_data {
	my ($self) = @_;
	return $self->_pithub_client->repos->get( user => $self->namespace, repo => $self->name );
}

1;
