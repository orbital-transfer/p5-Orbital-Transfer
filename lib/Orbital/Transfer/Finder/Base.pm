use Orbital::Transfer::Common::Setup;
package Orbital::Transfer::Finder::Base;
# ABSTRACT: Base class for file finders

use Mu;
use Orbital::Transfer::Common::Types qw(ArrayRef Path);

method all() :ReturnType(ArrayRef[Path]) { ... }

1;
