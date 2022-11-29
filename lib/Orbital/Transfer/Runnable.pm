use Orbital::Transfer::Common::Setup;
package Orbital::Transfer::Runnable;
# ABSTRACT: Base for runnable command

use Orbital::Transfer::Common::Setup;
use Mu;
use Orbital::Transfer::Common::Types qw(ArrayRef Str InstanceOf Bool);
use Types::TypeTiny qw(StringLike);

use Orbital::Transfer::EnvironmentVariables;

use MooX::Role::CloneSet qw();
with qw(MooX::Role::CloneSet);

has command => (
	is => 'ro',
	isa => ArrayRef[StringLike],
	coerce => 1,
	required => 1,
);

has environment => (
	is => 'ro',
	isa => InstanceOf['Orbital::Transfer::EnvironmentVariables'],
	default => sub { Orbital::Transfer::EnvironmentVariables->new },
);

has admin_privilege => (
	is => 'ro',
	isa => Bool,
	default => sub { 0 },
);

1;
