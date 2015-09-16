package Project::Manager::Platform::Coveralls;

use Moo;
use HTTP::Tiny;
use HTTP::CookieJar;

has coveralls_domain => ( is => 'rw',
	default => sub {'https://coveralls.io/'} );

has ua => ( is => 'lazy' );

sub _build_ua {
	HTTP::Tiny->new( cookie_jar => HTTP::CookieJar->new );
}

sub get_index{
	my ($self) = @_;
	$self->ua->get( $self->coveralls_domain );
}

sub auth_to_github {
	my $auth_url = 'https://coveralls.io/authorize/github'
}

sub auth_to_bitbucket {
	my $auth_url = 'https://coveralls.io/authorize/bitbucket'
}

# TODO
# - login via GitHub
# - retrieve a list of repositories
# - add a repository from GitHub name
# - list setting for repository
# - get a list of builds (timestamp, commit SHA)
# - get the coverage for a build
# - get the coverage of each file in the build

1;
