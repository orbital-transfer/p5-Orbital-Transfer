package Project::Manager::Repo::Git;

use strict;
use warnings;

use Moo;
use Git::Wrapper;

has directory => ( is => 'ro', required => 1 );

has _git_wrapper => ( is => 'lazy' ); # _build__git_wrapper

# TODO note that there can be multiple push remotes
# (and only a single fetch remote? check this)
has remotes => ( is => 'lazy', clearer => 1 ); # _build_remotes

sub _build__git_wrapper {
	my ($self) = @_;
	Git::Wrapper->new( { dir => $self->directory } );
}

sub _build_remotes {
	my ($self) = @_;

	my %remote_data;

	my @remotes = $self->_git_wrapper->remote( { verbose => 1 });
	for my $remote (@remotes) {
		if( $remote =~ m,^(\S+) \s+ (\S+) \s+ \((fetch|push)\)$,x ) {
			my $remote_name = $1;
			my $remote_uri = $2;
			my $remote_type = $3;

			my $target_ref = \( $remote_data{ $remote_name }{$remote_type} );
			# TODO Test this.
			# This allows for multiple (push) refs
			if( defined $$target_ref ) {
				unless( ref $$target_ref ) {
					$$target_ref = [ $$target_ref ];
				}
				push @$$target_ref, $remote_uri;
			} else {
				$$target_ref = $remote_uri;
			}
		} else {
			die "error parsing remotes for @{[ $self->directory ]}";
		}
	}

	\%remote_data;
}

1;
