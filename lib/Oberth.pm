use Oberth::Common::Setup;
package Oberth;
# ABSTRACT: Run Oberth

use Moo;
use CLI::Osprey;

subcommand config => 'Oberth::Command::Config';
subcommand list => 'Oberth::Command::List';

method run(@) {
	...
}

1;
