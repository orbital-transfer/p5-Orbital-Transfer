package Project::Manager::UI::Term;

use strict;
use warnings;

use Moo;
use Tickit;
use Tickit::Widget::Box;
use Tickit::Widget::Static;

sub run {
	my $box = Tickit::Widget::Box->new(
		h_border => 4,
		v_border => 2,
		bg       => "green",
		child    => Tickit::Widget::Static->new(
			text     => "Hello, world!",
			bg       => "black",
			align    => "centre",
			valign   => "middle",
		),
	);
	Tickit->new( root => $box )->run;
}

1;
