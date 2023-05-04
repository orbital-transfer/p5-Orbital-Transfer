use Orbital::Transfer::Common::Setup;
package Orbital::Transfer::Builder::Role::BuildClass;
# ABSTRACT: With a class to build

use namespace::autoclean;
use Mu::Role;

use Orbital::Transfer::Common::Types qw(ClassName);

ro build_class => (
	isa => ClassName,
);

method build($args) {
	$self->build_class->new( $args );
}

1;
