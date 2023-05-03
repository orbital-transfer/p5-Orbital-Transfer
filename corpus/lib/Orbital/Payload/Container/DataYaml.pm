use Orbital::Transfer::Common::Setup;
package Orbital::Payload::Container::DataYaml;
# ABSTRACT: Container for data.yml projects

use Mu;

extends 'Orbital::Transfer::Container::Base';

sub initialize {
	return {
		finder => [ qw(Orbital::Payload::Finder::DataYaml) ],
	};
}

1;
