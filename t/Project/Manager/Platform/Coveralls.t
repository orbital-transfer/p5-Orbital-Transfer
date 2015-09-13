use strict;
use warnings;
use Test::More;

use Project::Manager::Platform::Coveralls;

my $cv = Project::Manager::Platform::Coveralls->new;

$cv->repos;
