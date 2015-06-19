package Project::Manager::Platform::GitHub;

use LWP::UserAgent;
use HTTP::Request;
use Net::Netrc;
use List::AllUtils qw(first);

sub create_token_interactive {
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
	my $mach = first { defined Net::Netrc->lookup($_) } qw(github.com api.github.com);
	if( Net::Netrc->lookup('api.github.com')  ) {
		my ($user, $pass) = $mach->login;
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

sub create_token {
	my ($self, %opt) = @_;

	my $username = $opt{username};
	my $password = $opt{password};

	my $parameters = {
		scopes   => ["user", "read:org"],
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
		print "GITHUB_OAUTH_TOKEN=$response_content->{token}\n";
	}
	else {
		print $response_content->{message} || "Unspecified error", "\n";
	}

}
