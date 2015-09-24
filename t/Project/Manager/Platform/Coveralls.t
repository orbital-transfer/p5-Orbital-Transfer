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

use HTML::TreeBuilder::XPath;
my $coveralls_tree = HTML::TreeBuilder::XPath->new_from_content(
	$cv->ua->get('https://coveralls.io/')->decoded_content
);

my @repos = $coveralls_tree->findnodes( q|//div[@class='repoOverview']| );
my @repos_text = map { $_->as_text } @repos;
use DDP; p @repos_text;

$cv->repos;
