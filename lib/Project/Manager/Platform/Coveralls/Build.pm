package Project::Manager::Platform::Coveralls::Build;

use strict;
use warnings;

use Moo;

has [ qw(branch build commit committer coverage time type via) ] => ( is => 'ro' );

sub new_from_table_headers {
	my ($class, %table_hash) = @_;
	my %headers_to_attr =  map { $_ => lc $_ } qw(Branch Build Commit Committer Coverage Time Type Via);
	$class->new(
		map {
			  exists $headers_to_attr{$_}
			? ( $headers_to_attr{$_} => $table_hash{$_} )
			: ( );
		} keys %table_hash
	);
}

1;
