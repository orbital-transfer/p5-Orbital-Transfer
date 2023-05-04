use Orbital::Transfer::Common::Setup;
package Orbital::Payload::Metadata::DataYaml;
# ABSTRACT: A mocked up data source

use Mu;

use YAML ();

extends 'Orbital::Transfer::MetaProp::Base';

lazy data_yaml_path => method() {
	$self->parent->directory->child('data.yml');
};

lazy _contents => method() { YAML::LoadFile( $self->data_yaml_path ) };

method direct_dependencies() { ...  }

1;
