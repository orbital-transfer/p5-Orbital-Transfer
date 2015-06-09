package Project::Manager::Platform::GitHub;

use Modern::Perl;
use Moo;

has uri => ( is => 'ro', trigger => 1 ); # _trigger_uri

has git_scp_uri => ( is => 'lazy' ); # _build_git_scp_uri
sub _build_git_scp_uri {
	my ($self) = @_;
	return "git\@github.com:@{[ $self->namespace ]}/@{[ $self->name ]}.git";
}

has [ qw{namespace name} ] => ( is => 'rw' );


sub _trigger_uri {
	my ($self, $uri) = @_;
	if( $uri =~ m,
		        ^
		(?:
			  git\@github\.com:
			| git://github\.com/
			| https? :// github\.com/
		)
		(         [^/\s]+    )
		        /
		(         [^/\s]+    )
		        $,x ) {

		my $namespace = $1;
		my $name = $2;
		$name =~ s/.git$//;

		$self->namespace( $namespace );
		$self->name( $name );

	} else {
		die "invalid GitHub URI: $uri";
	}
}

1;
