use strict;
use warnings;

use Test::More tests => 5;
use Test::Exception;

use Project::Manager::Platform::GitHub::User;

my $user = Project::Manager::Platform::GitHub::User->new( user => 'zmughal' );
use DDP; p $user->repos->first_page_uri;
