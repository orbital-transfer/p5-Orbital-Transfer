package Project::Manager::Issue;

use strict;
use warnings;

use Moo;

has [ qw{name state} ] => ( is => 'rw' );

1;
