package Project::Manager::Platform::GitHub::User;

use Modern::Perl;
use Moo;
use Pithub;

with qw(Project::Manager::Platform::GitHub::PithubRole);

has user => ( is => 'ro', required => 1 );

sub repos {
	my ($self) = @_;
	return $self->_pithub_client->repos->list( user => $self );
}

1;
