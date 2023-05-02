#!/usr/bin/env perl

use Test2::V0;

use lib 'corpus/lib';

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

	my $finder = Orbital::Transfer::Finder::ByPIR->new(
		rule => Path::Iterator::Rule->new->dir->and(
			sub { -f path($_)->child('data.yml') }
		),
		directories => [ 'corpus/workspace-1' ]
	);

	$workspace->add_project( map $MyProject->new( directory => $_ ), @{ $finder->all } );

	is $workspace, $workspace_test , 'check workspace';
};

done_testing;
