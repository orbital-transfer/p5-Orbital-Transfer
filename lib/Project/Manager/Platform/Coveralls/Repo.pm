package Project::Manager::Platform::Coveralls::Repo;

use strict;
use warnings;

use Moo;
use MooX::HandlesVia;

has coveralls_domain => ( is => 'ro', required => 1 );
has repo_overview_node => ( is => 'rw' );

has _node_coverage_text => ( is => 'lazy');
	sub _build__node_coverage_text {
		my ($self) = @_;
		my ($coverage_text_node) = $self->repo_overview_node->findnodes('.//div[contains(@class,"coverageText")]');
	}

has _node_coverage_head_links => (
	is => 'lazy',
	handles_via => 'Array',
	handles => {
		_node_coverage_org  => [ get => 0 ],
		_node_coverage_repo => [ get => 1 ],
	},
);
	sub _build__node_coverage_head_links {
		my ($self) = @_;
		[ my ($coveralls_org_node, $coveralls_repo_node) = $self->repo_overview_node->findnodes('.//h1/a') ];
	}

has _text_formatter => ( is => 'lazy' );
	sub _build__text_formatter {
		my $fmt_text = HTML::FormatText->new;
	}

has build_text => ( is => 'lazy' );
sub _build_build_text {

}




1;
