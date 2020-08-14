use Modern::Perl;
package Orbital::Transfer::Common::Error;
# ABSTRACT: Common exceptions/errors for Orbital

use custom::failures qw/
	IO::FileNotFound
	Authorization
	Service::NotAvailable
	Retrieval::NotFound
	/;

1;
