#!/usr/bin/env perl

use Test2::V0;

use lib 'corpus/lib';
BEGIN {
	require Module::Pluggable;
	$Module::Pluggable::FORCE_SEARCH_ALL_PATHS = 1;
}

use Orbital::Transfer;
use Object::Util magic => 0;
use aliased 'Orbital::Transfer::Workspace';
use aliased 'Orbital::Transfer::Project';
use With::Roles;

use Orbital::Transfer::Finder::ByPIR;

my $MyProject = Project->with::roles('Orbital::Transfer::Role::Locatable::ByDir');

my $workspace_test = object {
	call 'projects' => array {
		prop size => 4;
		item object {
			call 'directory', object {
				prop isa => 'Path::Tiny';
				call is_dir => T();
			};
		};
		etc;
	};
};

subtest "Create workspace manually" => sub {
	my $workspace = Workspace->new;
	$workspace->add_project( $MyProject->new( directory => 'corpus/workspace-1/project-a' ) );
	$workspace->add_project( $MyProject->new( directory => 'corpus/workspace-1/project-b' ) );
	$workspace->add_project( $MyProject->new( directory => 'corpus/workspace-1/project-c' ) );
	$workspace->add_project( $MyProject->new( directory => 'corpus/workspace-1/project-d' ) );
	is $workspace, $workspace_test , 'check workspace';
};

subtest 'Create workspace using finder' => sub {
	my $workspace = Workspace->new;

	my @containers = Orbital::Transfer->containers;

	is \@containers, bag { item 'Orbital::Payload::Container::DataYaml' }, 'has container';

	is [ Orbital::Transfer->finders ], bag { item 'Orbital::Payload::Finder::DataYaml' }, 'has finder';

	my @dirs = map {
		$_->$_new( directories => [ 'corpus/workspace-1' ] )->all->@*
	} Orbital::Payload::Container::DataYaml->initialize->{finder}->@*;

	$workspace->add_project( map $MyProject->new( directory => $_ ), @dirs );

	is $workspace, $workspace_test , 'check workspace';
};

done_testing;
