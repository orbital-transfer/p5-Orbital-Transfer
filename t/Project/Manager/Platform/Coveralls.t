use strict;
use warnings;
use Test::More;

use Project::Manager::Platform::Coveralls;
use Project::Manager::Platform::GitHub::User;
use Project::Manager::Config;

my $cv = Project::Manager::Platform::Coveralls->new;

my $user = Project::Manager::Platform::GitHub::User->new( user => 'zmughal' );
my $token = Project::Manager::Config->github_token;

$cv->repos;
