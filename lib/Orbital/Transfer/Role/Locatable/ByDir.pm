use Orbital::Transfer::Common::Setup;
package Orbital::Transfer::Role::Locatable::ByDir;
# ABSTRACT: A role for an object that can be located by a directory on the filesystem

use Mu::Role;

use Orbital::Transfer::Common::Types qw(AbsDir);

has directory => (
	is => 'ro',
	required => 1,
	coerce => 1,
	isa => AbsDir,
);

1;
