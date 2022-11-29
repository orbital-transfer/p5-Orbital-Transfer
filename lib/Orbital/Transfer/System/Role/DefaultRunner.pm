use Orbital::Transfer::Common::Setup;
package Orbital::Transfer::System::Role::DefaultRunner;
# ABSTRACT: Default runner

use Mu::Role;

use Orbital::Transfer::Runner::Default;

lazy runner => method() {
	Orbital::Transfer::Runner::Default->new;
};

1;
