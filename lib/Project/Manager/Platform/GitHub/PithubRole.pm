package Project::Manager::Platform::GitHub::PithubRole;

use Moo::Role;

use Pithub;
has _pithub_client => ( is => 'lazy' ); # _build__pithub_client

sub _build__pithub_client {
	Pithub->new;
}


1;
