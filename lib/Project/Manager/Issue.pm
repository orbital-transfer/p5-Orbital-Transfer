package Project::Manager::Issue;

use strict;
use warnings;

use Moo;

has [ qw{number title description state} ] => ( is => 'rw' );

1;
