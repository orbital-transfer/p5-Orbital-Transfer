use Orbital::Transfer::Common::Setup;
package Orbital::Transfer::Role::Locatable::ByDir;
# ABSTRACT: A role for an object that can be located by a directory on the filesystem

use namespace::autoclean;
use Mu::Role;

use Orbital::Transfer::Common::Types qw(AbsDir);
use URI::file;

with qw(Orbital::Transfer::Role::IdentifiableURI);

has directory => (
	is => 'ro',
	required => 1,
	coerce => 1,
	isa => AbsDir,
);

lazy '+id_uri' => method() {
	local $URI::file::DEFAULT_AUTHORITY = 'localhost';
	URI::file->new( $self->directory );
};

1;
