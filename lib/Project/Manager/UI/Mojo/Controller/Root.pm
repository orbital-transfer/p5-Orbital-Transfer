package Project::Manager::UI::Mojo::Controller::Root;
use Mojo::Base 'Mojolicious::Controller';

sub index {
	my $c = shift;
	my $gh_repo = $c->app->container->resolve( service => 'github_user' );
	use DDP; p $gh_repo->repos;
	$c->render(text => "Hello from @{[ __PACKAGE__ ]}.");
}

1;
