package Project::Manager;

use strict;
use warnings;

use Project::Manager::UI::Term;
use Project::Manager::UI::Mojo;
use Project::Manager::UI::Text;
use Project::Manager::UI::CLI;
use Bread::Board;
use Project::Manager::Platform::GitHub::User;
use Project::Manager::Config;
use Path::Tiny;
use File::HomeDir;
use CHI;
use DBM::Deep;

sub run {
	my ($self) = @_;

	unless( @ARGV ) {
		die "$0 [web|term|text] [opt...]"
	}

	my $ui_opt = shift @ARGV;
	my $ui_package;
	if( $ui_opt eq 'term' ) {
		$ui_package = "Project::Manager::UI::Term";
	} elsif( $ui_opt eq 'web' ) {
		$ui_package = "Project::Manager::UI::Mojo"
	} elsif( $ui_opt eq 'text' ) {
		$ui_package = "Project::Manager::UI::Text"
	} elsif( $ui_opt eq 'cli' ) {
		$ui_package = "Project::Manager::UI::CLI"
	} else {
		die "invalid UI type"
	}

	my $ui = $ui_package->new( container => $self->app_container );
	$ui->run(@ARGV);
}

sub app_container {
	my $c = container ProjectManager => as {
		service conf_dir => (
			block => sub {
				my $path = path(File::HomeDir->my_data(), qw(.project-manager));
				$path->mkpath;
				$path;
			}
		);
		service cache_dir => (
			block => sub {
				my $s = shift;
				my $path = $s->param('conf_dir')->child('cache');
				$path->mkpath;
				$path;
			},
			dependencies => [ 'conf_dir' ],
		);
		service cache => (
			block => sub {
				my $s = shift;
				CHI->new(
					driver => 'File',
					root_dir => "" . $s->param('cache_dir') );
			},
			dependencies => [ 'cache_dir' ],
		);
		service dbm => (
			block => sub {
				my $s = shift;
				my $filename = $s->param('conf_dir')->child('gh-issue.db');
				my $db = DBM::Deep->new(
					file => $filename,
					num_txns => 2,
				);
			},
			dependencies => [ 'conf_dir' ],
		);
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
