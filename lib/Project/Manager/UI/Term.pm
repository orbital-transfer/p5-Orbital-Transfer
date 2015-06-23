package Project::Manager::UI::Term;

use strict;
use warnings;

use Moo;
use Tickit;
use Tickit::Widget::Box;
use Tickit::Widget::VBox;
use Tickit::Widget::Static;
use Tickit::Widget::Table;
use Tickit::Widget::Menu;
use Tickit::Widget::Frame;
use Tickit::Widget::MenuBar;

has _tickit => ( is => 'lazy' ); # _build__tickit
has _widget_menubar => ( is => 'lazy' ); # _build__widget_menubar

sub run {
	my $self = __PACKAGE__->new;

	$self->add_menubar;
	$self->_tickit->run;
}

sub add_menubar {
	my ($self) = @_;
	my $vbox = Tickit::Widget::VBox->new;
	$self->_tickit->set_root_widget( $vbox );
	$vbox->add( $self->_widget_menubar );
}

sub _build__widget_menubar {
	my ($self) = @_;
	Tickit::Widget::MenuBar->new(
		items => [
			Tickit::Widget::Menu->new(
				name => "File",
				items => [
					Tickit::Widget::Menu::Item->new( name => "Configure", on_activate => sub { $self->screen_configure } ),
					Tickit::Widget::Menu::Item->new( name => "Exit", on_activate => sub { $self->_tickit->stop } ),
				],
			),
		]
	);
}

sub _build__tickit { Tickit->new; }

sub screen_configure {
	my ($self) = @_;
	my $conf_win = $self->_tickit->rootwin->make_sub(
		10, 10,
		15,
		15,
		);
	my $frame = Tickit::Widget::Frame->new;
	$frame->set_window( $conf_win );

	my $menu = Tickit::Widget::Menu->new(
		items => [
			Tickit::Widget::Menu::Item->new(
				name => "Add account",
				on_activate => sub { ... }
			),
			Tickit::Widget::Menu::Item->new(
				name => "Back",
				on_activate => sub { $conf_win->close }
			),
		],
	);
	$frame->add( $menu );
	$conf_win->show;
}

1;
