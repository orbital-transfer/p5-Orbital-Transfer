use Oberth::Manoeuvre::Common::Setup;
package Oberth::Manoeuvre::Service::Role::DocumentRetrievable;
# ABSTRACT: Role to retrieve documents

use Moo::Role;
use Oberth::Manoeuvre::Common::Types qw(Str);

method retrieve( (Str) $identifier ) {
	...
}

1;
