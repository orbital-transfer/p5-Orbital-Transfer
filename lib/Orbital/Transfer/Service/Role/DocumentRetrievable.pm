use Orbital::Transfer::Common::Setup;
package Orbital::Transfer::Service::Role::DocumentRetrievable;
# ABSTRACT: Role to retrieve documents

use Orbital::Transfer::Common::Setup;
use Moo::Role;
use Orbital::Transfer::Common::Types qw(Str);

method retrieve( (Str) $identifier ) {
	...
}

1;
