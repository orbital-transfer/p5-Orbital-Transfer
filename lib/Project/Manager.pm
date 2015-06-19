package Project::Manager;

use strict;
use warnings;

sub run {
	my $ui = Project::Manager::UI::Term->new;
	$ui->run;
}

1;
