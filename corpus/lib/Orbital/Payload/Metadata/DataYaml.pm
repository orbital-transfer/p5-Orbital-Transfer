use Orbital::Transfer::Common::Setup;
package Orbital::Payload::Metadata::DataYaml;
# ABSTRACT: A mocked up data source

use namespace::autoclean;
use Mu;

use YAML ();
use Path::Tiny;

use Orbital::Transfer::Package::Spec::Generic;

extends 'Orbital::Transfer::MetaProp::Base';

lazy data_yaml_path => sub {
	my $self = shift;
	$self->parent->directory->child('data.yml');
};

lazy _contents => sub { my $self = shift; YAML::LoadFile( $self->data_yaml_path ) };

lazy direct_dependencies => sub {
	my ($self) = @_;

	return [] unless $self->_contents;

	my @deps;

	for my $project ( ($self->_contents->{depends} || [])->@* ) {
		my $dir = path($project)->absolute( $self->data_yaml_path->parent )->realpath;
		my $lookup = URI::file->new( $dir );
		$lookup->authority('localhost');
		if(exists $self->parent->registry->objects->{ $lookup } ) {
			push @deps, $self->parent->registry->objects->{ $lookup };
		} else {
			push @deps, { directory => $dir };
		}
	}

	for my $package ( ($self->_contents->{packages} || [])->@* ) {
		push @deps, Orbital::Transfer::Package::Spec::Generic->new( name => $package );
	}

	\@deps;
};

1;
