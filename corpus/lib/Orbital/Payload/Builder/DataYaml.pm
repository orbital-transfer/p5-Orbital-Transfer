package Orbital::Payload::Builder::DataYaml;
# ABSTRACT: Builds projects

use Mu;

use aliased 'Orbital::Transfer::Project';
use With::Roles;

use Orbital::Payload::Metadata::DataYaml;

extends 'Orbital::Transfer::Builder::Base';

with qw(
	Orbital::Transfer::Builder::Role::BuildClass
	Orbital::Transfer::Builder::Role::RegistryInjector
);

ro '+build_class' => default => sub {
	Project->with::roles(qw(
		Orbital::Transfer::Role::Locatable::ByDir
		Orbital::Transfer::Role::Meta
		Orbital::Transfer::Role::HasRegistry
	));
};

around build => sub {
	my ( $orig, $self, $args ) = @_;
	my $p = $self->$orig($args);
	$p->add_meta_prop(
		Orbital::Payload::Metadata::DataYaml->new( parent => $p )
	);
	$p;
};

1;
