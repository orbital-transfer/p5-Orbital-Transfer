use Oberth::Common::Setup;
package Oberth::Service::Role::DocumentRetrievable;
# ABSTRACT: Role to retrieve documents

use Moo::Role;
use Oberth::Common::Types qw(Str);

method retrieve( (Str) $identifier ) {
	...
}

1;
