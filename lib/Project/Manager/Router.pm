package Project::Manager::Router;

use Moo;
extends 'Path::Router';

sub BUILD {
	my ($self) = @_;

	$self->add_route(
		'account/:site/:account/repo',
		target => 'show_all_repo_list' );
		$self->add_route(
			'account/:site/:account/feed',
			target => 'show_all_activity'  );
		$self->add_route(
			'account/:site/:account/ns/:namespace/feed',
			target => 'show_ns_feed' );
		$self->add_route(
			'account/:site/:account/ns/:namespace/repo',
			target => 'show_ns_repo_list' );
		$self->add_route(
			'account/:site/:account/ns/:namespace/repo/:repo/info',
			target => 'show_repo_info' );
		$self->add_route(
			'account/:site/:account/ns/:namespace/repo/:repo/feed',
			target => 'show_repo_feed' );
		$self->add_route(
			'account/:site/:account/ns/:namespace/repo/:repo/issue',
			target => 'show_repo_issue_list' );
		$self->add_route(
			'account/:site/:account/ns/:namespace/repo/:repo/issue/:id',
			target => 'show_repo_issue' );
		$self->add_route(
			'account/:site/:account/ns/:namespace/repo/:repo/pull',
			target => 'show_repo_pull_list' );
		$self->add_route(
			'account/:site/:account/ns/:namespace/repo/:repo/pull/:id',
			target => 'show_repo_pull' );
		$self->add_route(
			'account/:site/:account/ns/:namespace/repo/:repo/issue+pull',
			target => 'show_repo_issue_and_pull_list' );
}

1;
