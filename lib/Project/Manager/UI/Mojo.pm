package Project::Manager::UI::Mojo;

use Mojo::Base 'Mojolicious';
use Moo;
use Mojolicious;
with qw(Project::Manager::UI::Role::DI);

sub run {
	my ($self, @ARGV) = @_;
	# Start the Mojolicious command system
	$self->start(@ARGV);
}

sub startup {
	my ($self, %opt) = shift;

	$self->helper( container => $opt{container} );

	# Router
	my $r = $self->routes;

	$r->get('/')->to('root#index');

	# Normal route to controller
	$r->namespaces(['Project::Manager::UI::Mojo::Controller']);
}

1;
