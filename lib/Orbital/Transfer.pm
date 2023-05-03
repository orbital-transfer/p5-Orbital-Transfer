use Orbital::Transfer::Common::Setup;
package Orbital::Transfer;
# ABSTRACT: Software project manager

use strict;
use warnings;

use Module::Pluggable require => 1, search_path => [ 'Orbital::Payload::Container' ], sub_name => 'containers';

classmethod finders() {
	map {
		my $init = $_->initialize;
		exists $init->{finder} ? $init->{finder}->@* : ()
	} $class->containers;
}

1;
