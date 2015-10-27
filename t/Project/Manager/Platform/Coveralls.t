use strict;
use warnings;
use Test::More;


use Project::Manager::Platform::Coveralls;
use Project::Manager::Platform::GitHub::User;
use Project::Manager::Config;
use Project::Manager::Platform::GitHub;

my $cv = Project::Manager::Platform::Coveralls->new;

my %cred = Project::Manager::Platform::GitHub->_get_github_user_pass;

#$cred{password} = ".";
$cv->auth_to_github( \%cred );

#use DDP; p $auth_github_redirect_to_coveralls;

my $repos = $cv->repos;
my $first_repo = $repos->[0];

use DDP; p $first_repo;

my $repo_page = $cv->ua->get( $first_repo->repo_link );

use HTML::TreeBuilder::XPath;
use HTML::TableExtract;
my $tree = HTML::TreeBuilder::XPath->new_from_content( $repo_page->decoded_content );
my @tr = $tree->findnodes('//tr');;
my @tr_text = map { $_->as_trimmed_text } @tr;
use DDP; p @tr_text;

use List::MoreUtils qw/zip/;
use String::Strip qw(StripLTSpace);
my $te = HTML::TableExtract->new( slice_columns => 0 );
$te->parse( $repo_page->decoded_content );
my $table = $te->first_table_found;
my @rows = $table->rows;
my $header = shift @rows;

my @table_hashes = map {
	my @values = @$_;
	StripLTSpace($_) for @values;
	+{ zip @$header, @values };
} @rows;

use DDP; p @table_hashes;
