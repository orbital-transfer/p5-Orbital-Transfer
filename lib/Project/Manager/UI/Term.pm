package Project::Manager::UI::Term;

use strict;
use warnings;

use Moo;
use Tickit;
use Tickit::Widget::Box;
use Tickit::Widget::Static;
use Tickit::Widget::Table;
use Tickit::Widget::Menu;

has _tickit => ( is => 'lazy' ); # _build__tickit
has _widget_menu => ( is => 'lazy' ); # _build__widget_menu;

sub run {
	my $self = __PACKAGE__->new;

	my $menu = $self->_widget_menu;
	$menu->popup( $self->_tickit->rootwin, 5, 5 );
	$self->_tickit->run;
}

sub _build__widget_menu {
	my ($self) = @_;
	my $menu = Tickit::Widget::Menu->new(
	   items => [
	      Tickit::Widget::Menu::Item->new(
		 name => "Exit",
		 on_activate => sub { $self->_tickit->stop }
	      ),
	   ],
	);
}

sub _build__tickit { Tickit->new; }

1;
