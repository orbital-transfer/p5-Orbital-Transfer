package Project::Manager::Platform::GitHub;

use strict;
use warnings;

use LWP::UserAgent;
use HTTP::Request;
use Net::Netrc;
use List::AllUtils qw(first);
use JSON::MaybeXS;
use Project::Manager::Error;

sub create_token_interactive {
	my ($self) = @_;
	local $| = 1;
	print "Username: ";
	chomp(my $username = <>);
	print "Password: ";
	chomp(my $password = <>);
	print "\n\n";

	exit unless $username && $password;
	$self->create_token( username => $username, password => $password );
}

sub _get_github_user_pass {
	my $mach = first { defined }
		map { Net::Netrc->lookup($_) }
		qw(github.com api.github.com);
	if( $mach ) {
		my ($user, $pass) = $mach->lpa;
		return (
			username => $user,
			password => $pass,
		);
	} elsif ($ENV{GITHUB_USER} && $ENV{GITHUB_PASSWORD}) {
		return (
			username => $ENV{GITHUB_USER},
			password => $ENV{GITHUB_PASSWORD},
		);
	}
}

sub get_token {
	my ($self) = @_;
	my @cred = $self->_get_github_user_pass;
	if( @cred ) {
		return $self->create_token( @cred );
	}
}

sub create_token {
	my ($self, %opt) = @_;

	my $username = $opt{username};
	my $password = $opt{password};

	my $parameters = {
		scopes   => ["repo", "read:org"],
		note     => "Project::Manager",
		note_url => "https://github.com/SeeLucid/p5-Project-Manager",
	};

	my $ua = LWP::UserAgent->new;

	my $request = HTTP::Request->new(POST => 'https://api.github.com/authorizations');
	$request->authorization_basic($username, $password);
	$request->content(encode_json($parameters));

	my $response = $ua->request($request);

	my $response_content = decode_json($response->decoded_content);

	if ($response_content->{token} ) {
		return $response_content->{token};
	}
	else {
		Project::Manager::Error::Authorization->throw(
			   $response_content->{message}
			|| "Unspecified error",
		);
	}
}

1;
