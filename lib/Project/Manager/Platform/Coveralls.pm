package Project::Manager::Platform::Coveralls;

use Moo;
use LWP::UserAgent;
use HTTP::CookieJar;
use HTML::Form;

has coveralls_domain => ( is => 'rw',
	default => sub {'https://coveralls.io/'} );

has ua => ( is => 'lazy' );

sub _build_ua {
	my $ua = LWP::UserAgent->new(
		cookie_jar => {},
		requests_redirectable => [ qw(GET HEAD POST) ],
	);
}

sub get_index{
	my ($self) = @_;
	$self->ua->get( $self->coveralls_domain );
}

sub _find_github_auth_form {
	my ($self, $content) = @_;
	my ($gh_login_form) = grep { $_->action eq 'https://github.com/session' }
		HTML::Form->parse( $content );
	$gh_login_form;
}

sub auth_to_github {
	my ($self, $cred) = @_;
	my $auth_url = 'https://coveralls.io/authorize/github';
	my $auth_to_github_res = $self->ua->get( $auth_url );
	my $gh_login_form = $self->_find_github_auth_form( $auth_to_github_res );
	if( !$gh_login_form ) {
		# no login, already logged in?
		return $auth_to_github_res;
	}

	# set login parameters
	$gh_login_form->param('login', $cred->{username} );
	$gh_login_form->param('password', $cred->{password} );
	my $req = $gh_login_form->click;

	# send login request
	my $auth_github_redirect_to_coveralls = $self->ua->request( $req  );

	if( $self->_find_github_auth_form($auth_github_redirect_to_coveralls) ) {
		# still have login form, so that means we did not login
		die "Authorisation to GitHub failed"
	}

	return $auth_github_redirect_to_coveralls;
}

sub auth_to_bitbucket {
	my $auth_url = 'https://coveralls.io/authorize/bitbucket'
}

sub repos {
	...
	# - get the link to the corresponding GitHub repo
	# - turn that into a GitHub repo object
	# - get the coverage for the project
	# - time of last coverage build
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
