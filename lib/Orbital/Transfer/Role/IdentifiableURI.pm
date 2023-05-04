package Orbital::Transfer::Role::IdentifiableURI;
# ABSTRACT: A role to identify an object by URI

use Mu::Role;
use Orbital::Transfer::Common::Types qw(Uri);

has id_uri => (
	is => 'ro',
	required => 0,
	isa => Uri,
);

1;
