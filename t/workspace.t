#!/usr/bin/env perl

use Test2::V0;

use lib 'corpus/lib';

use aliased 'Orbital::Transfer::Workspace';
use aliased 'Orbital::Transfer::Project';
use With::Roles;

my $MyProject = Project->with::roles('Orbital::Transfer::Role::Locatable::ByDir');

subtest "Create workspace manually" => sub {
	my $workspace = Workspace->new;
	$workspace->add_project( $MyProject->new( directory => 'corpus/workspace-1/project-a' ) );
	$workspace->add_project( $MyProject->new( directory => 'corpus/workspace-1/project-b' ) );
	$workspace->add_project( $MyProject->new( directory => 'corpus/workspace-1/project-c' ) );
	$workspace->add_project( $MyProject->new( directory => 'corpus/workspace-1/project-d' ) );
	is $workspace, object {
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
	}, 'check workspace';
};

todo 'Create workspace using finder' => sub {
	fail;
};

done_testing;
