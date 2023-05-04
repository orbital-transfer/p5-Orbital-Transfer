package Orbital::Payload::Builder::DataYaml;
# ABSTRACT: Builds projects

use Mu;

use aliased 'Orbital::Transfer::Project';
use With::Roles;

use Orbital::Payload::Metadata::DataYaml;

ro build_class => default => sub {
	Project->with::roles(qw(
		Orbital::Transfer::Role::Locatable::ByDir
		Orbital::Transfer::Role::Meta
	));
};

sub build {
	my ($self, @rest) = @_;
	my $p = $self->build_class->new( @rest );
	$p->add_meta_prop(
		Orbital::Payload::Metadata::DataYaml->new( parent => $p )
	);
	$p;
}

1;
