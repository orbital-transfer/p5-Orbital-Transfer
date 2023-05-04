use Orbital::Transfer::Common::Setup;
package Orbital::Transfer::Finder::ByPIR;
# ABSTRACT: A finder that uses Path::Iterator::Rule

use Mu;
use Path::Iterator::Rule ();
use Path::Tiny;

extends 'Orbital::Transfer::Finder::Base';

use Orbital::Transfer::Common::Types qw(InstanceOf ArrayRef Dir);

ro 'rule' => isa => InstanceOf['Path::Iterator::Rule'];

ro 'directories' => isa => ArrayRef[Dir], coerce => 1;

method all() {
	return [ map +{ directory => path($_) }, $self->rule->all( @{ $self->directories } ) ];
}

1;
