use Orbital::Transfer::Common::Setup;
package Orbital::Transfer::Registry;
# ABSTRACT: A registry

use namespace::autoclean;
use Mu;

use Orbital::Transfer::Common::Types qw(Map Str ConsumerOf);
use Sub::HandlesVia;

sub _get_id_uri {
	shift->id_uri;
}

has 'objects' => (
	is => 'ro',
	isa => Map[Str,ConsumerOf['Orbital::Transfer::Role::IdentifiableURI']],
	default => sub { +{} },
	handles_via => 'Hash',
	handles => {
		has_object => sub { exists $_[0]->{ $_[1]->id_uri }         },
		get_object => sub {        $_[0]->{ $_[1]->id_uri }         },
		add_object => sub {        $_[0]->{ $_[1]->id_uri } = $_[1] },
	},
);

1;
