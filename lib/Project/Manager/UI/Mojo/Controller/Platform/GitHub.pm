package Project::Manager::UI::Mojo::Controller::Platform::GitHub;
use Mojo::Base 'Mojolicious::Controller';

sub repos {
	my $c = shift;
	my $gh_repo = $c->app->container->resolve( service => 'github_user' );
	my $r = $gh_repo->repos;
	my @repos;
	while( my $row = $r->next ) {
		push @repos, $row;
	}
	$c->render(json => \@repos );
}

1;
