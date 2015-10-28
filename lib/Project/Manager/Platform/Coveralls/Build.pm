package Project::Manager::Platform::Coveralls::Build;

use strict;
use warnings;

use Moo;

has [ qw(branch build commit committer coverage time type via) ] => ( is => 'ro' );

1;
