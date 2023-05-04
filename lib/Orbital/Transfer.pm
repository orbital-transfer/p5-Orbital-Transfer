use Orbital::Transfer::Common::Setup;
package Orbital::Transfer;
# ABSTRACT: Software project manager

use strict;
use warnings;

use Module::Pluggable require => 1, search_path => [ 'Orbital::Payload::Container' ], sub_name => 'containers';

classmethod finders(:$containers = undef) {
	$class->_plugin_by_type('finder', containers => $containers);
}

classmethod builders(:$containers = undef) {
	$class->_plugin_by_type('builder', containers => $containers);
}

classmethod _plugin_by_type($type, :$containers = undef) {
	map {
		my $init = $_->initialize;
		exists $init->{$type} ? $init->{$type}->@* : ()
	} defined $containers ? @$containers : $class->containers;
}

1;
