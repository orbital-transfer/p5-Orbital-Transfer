package Project::Manager::Platform::Coveralls::Repo;

use strict;
use warnings;

use Moo;

has repo_overview_node => ( is => 'rw' );

has build_text => ( is => 'ro' );


1;
