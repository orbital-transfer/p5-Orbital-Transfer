use Orbital::Transfer::Common::Setup;
package Orbital::Transfer::Role::Meta;
# ABSTRACT: Meta properties


use Moo::Role;

use Types::Standard qw(ArrayRef InstanceOf);
use Sub::HandlesVia;
use Sub::Trigger::Lock qw( Lock );


has meta_prop => (
	is => 'ro',
	trigger => Lock,
	isa => ArrayRef[InstanceOf['Orbital::Transfer::MetaProp::Base']],
	default => sub { [] },
	handles_via => 'Array',
	handles => {
		add_meta_prop => 'push',
	},
);

1;
