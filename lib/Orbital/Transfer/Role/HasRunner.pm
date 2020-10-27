use Modern::Perl;
package Orbital::Transfer::Role::HasRunner;
# ABSTRACT: Role that requires runner

use Mu::Role;

has runner => (
	is => 'ro',
	required => 1,
);

1;
