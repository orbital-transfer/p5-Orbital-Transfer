use strict;
use warnings;

use Test::More tests => 2;
use Test::Exception;

use Project::Manager::Platform::GitHub;

my %common_data = ( namespace => 'test', name => 'repo' );
my $data = [
	## Git URI
	{ uri => 'git://github.com/test/repo.git', %common_data },
	{ uri => 'git://github.com/test/repo', %common_data },

	## SCP syntax
	{ uri => 'git@github.com:test/repo.git' , %common_data },
	{ uri => 'git@github.com:test/repo' , %common_data },

	## HTTPS
	{ uri => 'https://github.com/test/repo.git' , %common_data },
	{ uri => 'https://github.com/test/repo' , %common_data },

	## HTTP
	{ uri => 'http://github.com/test/repo.git', %common_data  },
	{ uri => 'http://github.com/test/repo', %common_data  },
];

subtest "Throws exceptions for bad URIs" => sub {
	for my $repo (@$data) {
		lives_ok { Project::Manager::Platform::GitHub->new( uri => $repo->{uri} ) } 'valid GitHub URI';
	}
};

subtest "Correct name extraction" => sub {
	for my $repo (@$data) {
		my $gh = Project::Manager::Platform::GitHub->new( uri => $repo->{uri} );
		is( $gh->namespace, $repo->{namespace}, "correct namespace from $repo->{uri}" );
		is( $gh->name, $repo->{name}, "correct name from $repo->{uri}" );
	}
};

