use Orbital::Transfer::Common::Setup;
package Orbital::Config::v0;
# ABSTRACT: Config version 0

use namespace::autoclean;
use Mu;
use Types::Standard qw(CycleTuple StrMatch ArrayRef);
use Module::Runtime qw($module_name_rx);
use Object::Util magic => 0;
use List::Util::MaybeXS qw(pairmap);

use Exporter 'import';
our @EXPORT = qw(config define metadata);

our @REGISTRY = ();
our $WORKING;

ro '_configs' => (
	isa => CycleTuple[StrMatch[$module_name_rx],ArrayRef],
);

lazy configs => method() {
	[ pairmap {
		$a->$_new( @$b )
	} $self->_configs->@* ];
};


fun config( @configs ) {
	my $self = __PACKAGE__->new( _configs => \@configs );
}

sub define($&)  {
	my ($type, $code) = @_;
	my $thing = { type => $type };
	{
		local $WORKING = $thing;
		$code->();
	}
	push @REGISTRY, $thing;
}

sub metadata {
	my ($relation, $data) = @_;
	push $WORKING->{$relation}->@*, $data;
}

1;
