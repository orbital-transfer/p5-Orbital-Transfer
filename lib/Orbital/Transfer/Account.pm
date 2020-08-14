use Orbital::Transfer::Common::Setup;
package Orbital::Transfer::Account;
# ABSTRACT: A base class for accounts

use Moo;
use Orbital::Transfer::Common::Types qw(Str);

has username => (
	is => 'ro',
	isa => Str,
	required => 1,
);

1;
