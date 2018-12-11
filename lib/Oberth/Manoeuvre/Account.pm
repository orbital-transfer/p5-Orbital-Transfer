use Oberth::Manoeuvre::Common::Setup;
package Oberth::Manoeuvre::Account;
# ABSTRACT: A base class for accounts

use Moo;
use Oberth::Manoeuvre::Common::Types qw(Str);

has username => (
	is => 'ro',
	isa => Str,
	required => 1,
);

1;
