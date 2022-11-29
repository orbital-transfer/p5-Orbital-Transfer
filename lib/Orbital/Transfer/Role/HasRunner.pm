use Orbital::Transfer::Common::Setup;
package Orbital::Transfer::Role::HasRunner;
# ABSTRACT: Role that requires runner

use Mu::Role;

has runner => (
	is => 'ro',
	required => 1,
);

1;
