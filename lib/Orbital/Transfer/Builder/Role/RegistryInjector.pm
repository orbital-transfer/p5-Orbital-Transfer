use Orbital::Transfer::Common::Setup;
package Orbital::Transfer::Builder::Role::RegistryInjector;
# ABSTRACT: Injects registry into builder

use namespace::autoclean;
use Mu::Role;

with qw( Orbital::Transfer::Role::HasRegistry );

before build => method($args) {
	$args->{registry} = $self->registry;
};

around build => fun($orig, $self, @args) {
	my $p = $self->$orig(@args);
	$self->registry->add_object( $p );
};

1;
