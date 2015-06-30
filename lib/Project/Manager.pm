package Project::Manager;

use strict;
use warnings;

use Project::Manager::UI::Term;
use Project::Manager::UI::Mojo;
use Bread::Board;
use Project::Manager::Platform::GitHub::User;
use Project::Manager::Config;

sub run {
	my ($self) = @_;

	unless( @ARGV ) {
		die "$0 [web|term] [opt...]"
	}

	my $ui_opt = shift @ARGV;
	my $ui_package;
	if( $ui_opt eq 'term' ) {
		$ui_package = "Project::Manager::UI::Term";
	} elsif( $ui_opt eq 'web' ) {
		$ui_package = "Project::Manager::UI::Mojo"
	} else {
		die "invalid UI type"
	}

	my $ui = $ui_package->new( container => $self->app_container );
	$ui->run;
}

sub app_container {
	my $c = container ProjectManager => as {
		service github_token => Project::Manager::Config->github_token;

		service github_user => (
			block => sub {
				my $s = shift;
				my $gh = Project::Manager::Platform::GitHub::User->new(
					github_token => $s->param('github_token'),
					);
				$gh;
			},
			dependencies => [ 'github_token' ],
		);
	};
}

1;
