package Project::Manager::UI::Mojo;

use Mojo::Base 'Mojolicious';
use Moo;
use Mojolicious;
with qw(Project::Manager::UI::Role::DI);

# Route with placeholder
get '/' => sub {
	my $c = shift;
	my $gh_repo = $c->container->resolve('github_user');
	$c->render(text => "Hello from @{[ __PACKAGE__ ]}.");
};

sub run {
	# Start the Mojolicious command system
	app->start;
}

sub startup {
	my ($self, %opt) = shift;

	$self->helper( container => $opt{container} );
}

1;
