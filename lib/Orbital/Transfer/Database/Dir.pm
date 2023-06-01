use Orbital::Transfer::Common::Setup;
package Orbital::Transfer::Database::Dir;
# ABSTRACT: A database under a directory

use Mu;
use Orbital::Transfer::Common::Types qw(Dir);
use Path::Iterator::Rule ();
use Orbital::Transfer::Finder::ByPIR;

ro directory => (
	isa => Dir,
);

method orbs() {
	my $finder = Orbital::Transfer::Finder::ByPIR->new(
		rule => Path::Iterator::Rule->new->file->name('Orb'),
		directories => [ $self->directory ],
	);
	my @orbs = map {
		+{
			name => $_->{path}->parent->relative( $self->directory )->stringify,
			path => $_->{path},
		}
	} $finder->all->@*;
	\@orbs;
}

1;
