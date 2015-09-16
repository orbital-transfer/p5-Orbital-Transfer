use strict;
use warnings;
use Test::More;

use Project::Manager::Platform::Coveralls;
use Project::Manager::Platform::GitHub::User;
use Project::Manager::Config;
use Project::Manager::Platform::GitHub;

my $cv = Project::Manager::Platform::Coveralls->new;

my %cred = Project::Manager::Platform::GitHub->_get_github_user_pass;

use HTML::Form;
my $auth_to_github_url = 'https://coveralls.io/authorize/github';
my $auth_to_github_res = $cv->ua->get( $auth_to_github_url );
my ($gh_login_form) = grep { $_->action eq 'https://github.com/session' }
	HTML::Form->parse( $auth_to_github_res->{content}, $auth_to_github_res->{url} );
$gh_login_form->param('login', $cred{username} );
$gh_login_form->param('password', $cred{password} );
my $req = $gh_login_form->click;
use DDP; p $req;
use DDP; p $cv->ua->request( $req->method, $req->uri, { content => $req->content } );

$cv->repos;
