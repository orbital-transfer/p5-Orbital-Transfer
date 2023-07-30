use Orbital::Transfer::Common::Setup;
package Orbital::Payload::Finder::DataYaml;
# ABSTRACT: Finder for directories with data.yml

use Mu;
use Path::Tiny;

extends 'Orbital::Transfer::Finder::ByPIR';

ro rule => (
	default => sub {
		Path::Iterator::Rule->new->dir->and(
			sub { -f path($_)->child('data.yml') }
		)
	},
);

around all => sub {
	my ($orig, $self, @args) = @_;
	my $data = $orig->($self, @args);
	$_->{directory} = delete $_->{path} for $data->@*;
	$data;
};

1;
