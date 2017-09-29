use Modern::Perl;
package Oberth::Common::Error;
# ABSTRACT: Common exceptions/errors for Oberth

use custom::failures qw/
	IO::FileNotFound
	Authorization
	Service::NotAvailable
	Retrieval::NotFound
	/;

1;
