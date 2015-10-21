package Project::Manager::Platform::Coveralls;

use Moo;

use LWP::UserAgent;
use HTTP::CookieJar;
use HTML::Form;
use HTML::TreeBuilder::XPath;
use URI;
use HTML::FormatText;

use Types::Standard qw(Str InstanceOf);
use Project::Manager::Platform::Coveralls::Repo;

has coveralls_domain => ( is => 'rw',
	default => sub {URI->new('https://coveralls.io/')} );

has ua => ( is => 'lazy', isa => InstanceOf["LWP::UserAgent"] );

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
	my $auth_url = 'https://coveralls.io/authorize/bitbucket';
	...
}

# Contains the HTML of the base page for Coveralls (once logged in).
#
# builder: _build__base_html_content
has _base_html_content => ( is => 'lazy', isa => Str );
	sub _build__base_html_content {
		my ($self) = @_;
		return $self->ua->get($self->coveralls_domain)->decoded_content;
	}

# Contains an HTML::Tree of _base_html_content() with XPath support.
#
# Builder: _build__base_tree
has _base_tree => ( is => 'lazy', isa => InstanceOf["HTML::TreeBuilder::XPath"] );
	sub _build__base_tree {
		my ($self) = @_;
		return HTML::TreeBuilder::XPath->new_from_content(
			$self->_base_html_content,
		);
	}

=method repos

Returns an C<ArrayRef> of C<Project::Manager::Platform::Coveralls::Repo>
instances for every repository that is available under the current user's
Coveralls account.

Requires a login.

=cut
sub repos {
	my ($self) = @_;

	my $coveralls_base = $self->coveralls_domain;
	my $coveralls_tree = $self->_base_tree;
	my @repos = $coveralls_tree->findnodes( q|//div[@class='repoOverview']| );

	my @repos_data = map {
		my $r = Project::Manager::Platform::Coveralls::Repo->new(
				coveralls_domain => $coveralls_base,
				repo_overview_node => $_
			       );

		# TODO remove the lazy attribute getter
		my $attrs = 'Moo'->_constructor_maker_for('Project::Manager::Platform::Coveralls::Repo')->all_attribute_specs;
		for my $attr (keys %$attrs) {
			if( exists $attrs->{$attr}{lazy} ) {
				$r->$attr();
			}
		}

		$r
	} @repos;
	\@repos_data;
}

# TODO
# - add a repository from GitHub name
# - list setting for repository
# - get a list of builds (timestamp, commit SHA)
# - get the coverage for a build
# - get the coverage of each file in the build

1;
