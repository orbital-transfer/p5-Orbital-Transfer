use Modern::Perl;
package Orbital::Transfer::System::Role::Config;
# ABSTRACT: Has config

use Mu::Role;
use Orbital::Transfer::Common::Setup;

has config => (
	is => 'ro',
	required => 1,
);

1;
