package Project::Manager::Config;

use strict;
use warnings;

use Project::Manager::Platform::GitHub;

use YAML qw(LoadFile DumpFile);
use Path::Tiny;
# TODO CONF_FILE should be an attribute
use constant CONF_FILE => path('~/.project-manager.yml');

our $config = {};

sub import {
	load_config();
}

sub load_config {
	$config = LoadFile( CONF_FILE );
}

sub save_config {
	DumpFile( CONF_FILE, $config );
}


sub github_token {
	my ($self) = @_;
	unless( exists $config->{github_token} ) {
		$config->{github_token} =
			Project::Manager::Platform::GitHub->get_token;
		$self->save_config;
	}
	$config->{github_token};
}

1;
