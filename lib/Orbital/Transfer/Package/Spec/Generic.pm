use Orbital::Transfer::Common::Setup;
package Orbital::Transfer::Package::Spec::Generic;
# ABSTRACT: A generic package specification

use namespace::autoclean;
use Mu;
use Orbital::Transfer::Common::Types qw(Str);

extends 'Orbital::Transfer::Package::Spec::Base';

ro 'name' => isa => Str;

1;
