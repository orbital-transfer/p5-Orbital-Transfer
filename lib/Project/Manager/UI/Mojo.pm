package Project::Manager::UI::Mojo;

use Mojolicious::Lite;
use Moo;
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

1;
