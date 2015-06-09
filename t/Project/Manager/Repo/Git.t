
use strict;
use warnings;

use Test::More tests => 1;

use Project::Manager::Repo::Git;
use Path::Tiny;

my $gitdir = path('~/sw_projects/bluebonnet/p5-Bluebonnet-Converter/p5-Bluebonnet-Converter');

my $gr = Project::Manager::Repo::Git->new( directory => $gitdir );
is( $gr->remotes->{origin}{fetch}, 'git@github.com:bluebonnet/p5-Bluebonnet-Converter.git' );

