package Orbital::Transfer::Workspace;
# ABSTRACT: A container for one or more related projects

use Moo;
use Types::Standard qw(ArrayRef InstanceOf);
use Sub::HandlesVia;
use Sub::Trigger::Lock qw( Lock unlock );

has projects => (
	is => 'ro',
	trigger => Lock,
	isa => ArrayRef[InstanceOf['Orbital::Transfer::Project']],
	default => sub { [] },
	handles_via => 'Array',
	handles => {
		add_project => 'push',
	},
);

1;
