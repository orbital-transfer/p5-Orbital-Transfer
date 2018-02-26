use Oberth::Common::Setup;
package Oberth::Account;
# ABSTRACT: A base class for accounts

use Moo;
use Oberth::Common::Types qw(Str);

has username => (
	is => 'ro',
	isa => Str,
	required => 1,
);

1;
