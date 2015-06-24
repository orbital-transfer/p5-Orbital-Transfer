use strict;
use warnings;

use Modern::Perl;
use Test::More tests => 1;
use Test::Exception;

use Project::Manager::Platform::GitHub::User;
use Project::Manager::Config;

my $user = Project::Manager::Platform::GitHub::User->new( user => 'zmughal' );
my $token = Project::Manager::Config->github_token;
my $r = $user->_pithub_client
	->repos(
		token => $token,
		auto_pagination => 1,
	)->list(
		#user => 'zmughal',
		params => { type => 'all' },
		options => $user->_pithub_options,
	);
#use DDP; p $r;
#use DDP; p $r->response->request->as_string;
#say $r->next_page_uri;
#say $r->count;
#exit;
while( my $row = $r->next ) {
	say $row->{full_name};
}
#do {
	#use DDP; p $r->request;
	#my @fn = map { $_->{full_name} } @{ $r->content };
	#use DDP; p @fn;
#} while( $r = $r->next_page );
#use DDP; p $user->repos->first_page_uri;


# TODO
ok 1;
