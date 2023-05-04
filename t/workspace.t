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
use aliased 'Orbital::Transfer::Registry';
use With::Roles;

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
	my $MyProject = Project->with::roles('Orbital::Transfer::Role::Locatable::ByDir');
	my $workspace = Workspace->new;
	$workspace->add_project( $MyProject->new( directory => 'corpus/workspace-1/project-a' ) );
	$workspace->add_project( $MyProject->new( directory => 'corpus/workspace-1/project-b' ) );
	$workspace->add_project( $MyProject->new( directory => 'corpus/workspace-1/project-c' ) );
	$workspace->add_project( $MyProject->new( directory => 'corpus/workspace-1/project-d' ) );
	is $workspace, $workspace_test , 'check workspace';
};

subtest 'Create workspace using finder' => sub {
	my $workspace = Workspace->new;
	my $registry = Registry->new;

	my $test_container = 'Orbital::Payload::Container::DataYaml';

	my @containers = Orbital::Transfer->containers;

	is \@containers, bag { item $test_container }, 'has container';

	is [ Orbital::Transfer->finders ], bag { item 'Orbital::Payload::Finder::DataYaml' }, 'has finder';

	my @projects = map {
		( Orbital::Transfer->builders( containers => [$test_container] ) )[0]->$_new( registry => $registry )->build(
			$_
		);
	} map {
		$_->$_new( directories => [ 'corpus/workspace-1' ] )->all->@*
	} Orbital::Transfer->finders( containers => [ $test_container ]);

	$workspace->add_project( @projects );

	is $workspace, $workspace_test , 'check workspace';

	is $workspace->projects, bag {
		item object {
			call directory => object {
				call basename => string 'project-b';
			};
			call meta_prop => bag {
				item object {
					prop isa => 'Orbital::Payload::Metadata::DataYaml';
					call direct_dependencies => bag {
						prop size => 5;
						for my $project (qr/project-d/, qr/project-c/) {
							item object {
								check_isa Project;
								call id_uri => object { call as_string => match $project };
							};
						}
						for my $package (qw(foo baz)) {
							item object {
								check_isa 'Orbital::Transfer::Package::Spec::Generic';
								call name => $package;
							};
						}
						item hash {
							field directory => object { call stringify => match qr{/workspace-1/project-z$} };
						};
						end();
					};
				};
				etc();
			};
		};
		etc();
	}, 'check project-b';
};

done_testing;
