package Project::Manager::UI::CLI;

use Moo;
use autodie;
use FindBin;

use Project::Manager::Repo::Git;
use Project::Manager::Platform::GitHub::Repo;

with qw(Project::Manager::UI::Role::DI);

sub run {
	my ($self, @args) = @_;
}

1;
