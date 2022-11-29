use Orbital::Transfer::Common::Setup;
package Orbital::Transfer::System::Role::Config;
# ABSTRACT: Has config

use Orbital::Transfer::Common::Setup;
use Mu::Role;

has config => (
	is => 'ro',
	required => 1,
);

1;
