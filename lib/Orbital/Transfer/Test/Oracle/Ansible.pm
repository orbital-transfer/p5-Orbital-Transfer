package Orbital::Transfer::Test::Oracle::Ansible;
# ABSTRACT: A pseudo-oracle for querying Ansible

use Orbital::Transfer::Common::Setup;
use Mu;

use File::Which;
use JSON::MaybeXS qw(decode_json);
use Orbital::Transfer::Runnable;

with qw(Orbital::Transfer::System::Role::DefaultRunner);

ro path_to_ansible => ( default => 'ansible' );

method can_query() {
	return !! which( $self->path_to_ansible );
}

sub query_localhost_builtin_setup {
	my ($self) = @_;

	my $r = Orbital::Transfer::Runnable->new(
		command => [qw( ansible localhost -m ansible.builtin.setup )],
	);
	my $output = $self->runner->capture( $r );
	# Output is:
	#   localhost | SUCCESS => {}
	my ($host, $result, $json) = $output =~ /
		\A
		(\S+)          # host
		\Q | \E
		(SUCCESS)      # result
		\Q => \E
		(.*)           # JSON
		\Z
		/xs;

	my $data = decode_json( $json );

	return $data;
}


1;
