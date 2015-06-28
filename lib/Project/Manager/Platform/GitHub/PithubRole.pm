package Project::Manager::Platform::GitHub::PithubRole;

use strict;
use warnings;

use Moo::Role;

use Pithub;

has github_token => ( is => 'rw' );

has _pithub_client => ( is => 'lazy' ); # _build__pithub_client

sub _build__pithub_client {
	Pithub->new;
}

has _pithub_options => ( is => 'lazy' ); # _build__pithub_options

sub _build__pithub_options {
	return +{
		prepare_request => sub {
			my ($request) = @_;
			# add header for GitHub API change preview. Changes take
			# effect officially June 24.
			# See:
			#   - <https://developer.github.com/changes/2015-01-07-prepare-for-organization-permissions-changes/>
			#   - <https://developer.github.com/changes/2014-12-08-organization-permissions-api-preview/>
			$request->header( Accept => 'application/vnd.github.moondragon+json; charset=utf-8,application/vnd.github.v3+json; charset=utf-8' );
		}
	};
}


1;
