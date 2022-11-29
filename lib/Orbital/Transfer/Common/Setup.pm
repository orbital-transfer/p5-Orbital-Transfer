use strict;
use warnings;
package Orbital::Transfer::Common::Setup;
# ABSTRACT: Packages that can be imported into every module

use autodie;

use Import::Into;
use Importer ();

use Function::Parameters ();
use Return::Type ();
use MooX::TypeTiny ();

use Try::Tiny ();
use Orbital::Transfer::Common::Error ();

use Path::Tiny ();


sub import {
	my ($class) = @_;

	my $target = caller;

	strict->import::into( $target );
	warnings->import::into( $target );
	autodie->import::into( $target );

	my %type_tiny_fp_check = ( reify_type => sub { Type::Utils::dwim_type($_[0]) }, );
	Function::Parameters->import::into( $target,
		{
			fun         => { defaults => 'function_lax'   , %type_tiny_fp_check },
			classmethod => { defaults => 'classmethod_lax', %type_tiny_fp_check },
			method      => { defaults => 'method_lax'     , %type_tiny_fp_check },
		}
	);
	Return::Type->import::into( $target );

	# Use postfix so that PPR does not need modification relative to the
	# built-in feature 'try'.
	Importer->import_into('Try::Tiny', $target, (
		map {
			$_ => { -postfix => '_tt' },
		} qw(try catch finally)
	));
	Orbital::Transfer::Common::Error->import::into( $target );

	Path::Tiny->import::into( $target );

	return;
}

1;
