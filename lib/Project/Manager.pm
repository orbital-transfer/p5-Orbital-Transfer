package Project::Manager;

use strict;
use warnings;

use Project::Manager::UI::Term;

sub run {
	my $ui = Project::Manager::UI::Term->new;
	$ui->run;
}

1;
