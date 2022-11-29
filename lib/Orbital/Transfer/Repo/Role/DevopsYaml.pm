use Orbital::Transfer::Common::Setup;
package Orbital::Transfer::Repo::Role::DevopsYaml;
# ABSTRACT: A role for reading devops configuration from YAML

use Orbital::Transfer::Common::Setup;
use Mu::Role;
use YAML;

lazy devops_config_path => method() {
	File::Spec->catfile( $self->directory, qw(maint devops.yml) );
};

lazy devops_data => method() {
	YAML::LoadFile( $self->devops_config_path );
};

method debian_get_packages() {
	my $data = [];
	if( -r $self->devops_config_path ) {
		push @$data, @{ $self->devops_data->{native}{debian}{packages} || [] };
	}

	return $data;
}

method homebrew_get_packages() {
	my $data = [];
	if( -r $self->devops_config_path ) {
		push @$data, @{ $self->devops_data->{native}{'macos-homebrew'}{packages} || [] };
	}

	return $data;
}

method msys2_mingw64_get_packages() {
	my $data = [];
	if( -r $self->devops_config_path ) {
		push @$data, @{ $self->devops_data->{native}{'msys2-mingw64'}{packages} || [] };
	}

	return $data;
}

method chocolatey_get_packages() {
	my $data = [];
	if( -r $self->devops_config_path ) {
		push @$data, @{ $self->devops_data->{native}{'chocolatey'}{packages} || [] };
	}

	return $data;
}

1;
