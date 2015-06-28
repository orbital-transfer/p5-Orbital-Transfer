package Project::Manager;

use strict;
use warnings;

use Project::Manager::UI::Term;
use Bread::Board;

sub run {
	my ($self) = @_;

	my $ui_opt = shift @ARGV;

	my $ui_package = "Project::Manager::UI::Mojo";
	if( $ui_opt eq 'term' ) {
		$ui_package = "Project::Manager::UI::Term";
	} elsif( $ui_opt eq 'web' ) {
		$ui_package = "Project::Manager::UI::Mojo"
	}

	my $ui = $ui_package->new( container => $self->app_container );
	$ui->run;
}

sub app_container {
	...
}

1;
