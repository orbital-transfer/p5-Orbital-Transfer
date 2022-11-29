use Orbital::Transfer::Common::Setup;
package Orbital::Transfer::Config;
# ABSTRACT: Configuration

use Mu;

use Path::Tiny;
use FindBin;
use Env qw($ORBITAL_GLOBAL_INSTALL $ORBITAL_COVERAGE);

lazy base_dir => sub {
	my $p;
	if( $ENV{CI} ) {
		$p = path('~/.orbital')->absolute;
	} else {
		$p = path('..')->absolute;
	}
	$p->mkpath;
	$p->realpath;
};

lazy build_tools_dir => sub {
	my ($self) = @_;
	my $p = $self->base_dir->child('_orbital/author-local');
	$p->mkpath;
	$p->realpath;
};

lazy lib_dir => sub {
	my ($self) = @_;
	my $p = $self->base_dir->child('local');
	$p->mkpath;
	$p->realpath;
};

lazy meta_file => sub {
	my ($self) = @_;
	$self->lib_dir->child('.orbital-meta');
};

lazy external_dir => sub {
	my ($self) = @_;
	my $p = $self->base_dir->child(qw(_orbital external));
	$p->mkpath;
	$p->realpath;
};

has cpan_global_install => (
	is => 'ro',
	default => sub {
		my $global = $ORBITAL_GLOBAL_INSTALL // 0;
	},
);

method has_orbital_coverage() {
	exists $ENV{ORBITAL_COVERAGE} && $ENV{ORBITAL_COVERAGE};
}

method orbital_coverage() {
	$ENV{ORBITAL_COVERAGE};
}

1;
