use Orbital::Transfer::Common::Setup;
package Orbital::Transfer::Repo;
# ABSTRACT: Represent the top level of a code base repo

use Orbital::Transfer::Common::Setup;
use Mu;

has [ qw(config platform) ] => (
	is => 'ro',
	required => 1,
);

lazy runner => method() {
	$self->platform->runner;
};

with qw(
	Orbital::Transfer::Role::Locatable::ByDir
);

1;
