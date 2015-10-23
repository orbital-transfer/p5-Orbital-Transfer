use strict;
use warnings;
use Test::More;

use Project::Manager::Platform::Coveralls;
use Project::Manager::Platform::GitHub::User;
use Project::Manager::Config;
use Project::Manager::Platform::GitHub;

my $cv = Project::Manager::Platform::Coveralls->new;

my %cred = Project::Manager::Platform::GitHub->_get_github_user_pass;

#$cred{password} = ".";
$cv->auth_to_github( \%cred );

#use DDP; p $auth_github_redirect_to_coveralls;

my $repos = $cv->repos;
my $first_repo = $repos->[0];

use DDP; p $first_repo;

my $repo_page = $cv->ua->get( $first_repo->repo_link );

use DDP; p $repo_page;
