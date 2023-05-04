use Orbital::Transfer::Common::Setup;
package Orbital::Transfer::Role::HasRegistry;
# ABSTRACT: A role that gives access to a registry

use namespace::autoclean;
use Mu::Role;
use Orbital::Transfer::Common::Types qw(InstanceOf);

ro registry => (
	isa => InstanceOf['Orbital::Transfer::Registry'],
);

1;
