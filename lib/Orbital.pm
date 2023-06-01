use Orbital::Transfer::Common::Setup;
package Orbital;
# ABSTRACT: Orbital namespace

use Importer;

sub import {
	my ($package, %args) = @_;

	my $target = caller;

	if( $args{'-type'} eq 'config' ) {
		if( $args{'-version'} eq 'v0' ) {
			use Orbital::Config::v0;
			Importer->import_into('Orbital::Config::v0', $target, qw(config));
		}
	} elsif( $args{'-type'} eq 'define' ) {
		if( $args{'-version'} eq 'v0' ) {
			use Orbital::Config::v0;
			Importer->import_into('Orbital::Config::v0', $target, qw(define metadata));
		}
	} else {
		die "Unknown type of orbitalfile";
	}
}

1;
