package Project::Manager::Platform::Coveralls::Repo;

# TODO
# - get the coverage for the project
# - time of last coverage build

use strict;
use warnings;

use Moo;
use MooX::HandlesVia;
use String::Strip qw(StripLTSpace);

has coveralls_domain => ( is => 'ro', required => 1 );
has repo_overview_node => ( is => 'rw' );

has _node_coverage_text => ( is => 'lazy');
	sub _build__node_coverage_text {
		my ($self) = @_;
		my ($coverage_text_node) = $self->repo_overview_node->findnodes('.//div[contains(@class,"coverageText")]');
		$coverage_text_node;
	}
has coverage_text => ( is => 'lazy' );
	sub _build_coverage_text {
		my ($self) = @_;
		( $self->_node_coverage_text ) ? ( $self->_node_coverage_text->as_trimmed_text ) : (),
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

has _node_build_summary => ( is => 'lazy',);
	sub _build__node_build_summary {
		my ($self) = @_;
		my ($build_summary) = $self->repo_overview_node->findnodes('.//div[contains(@class,"summary")]');
		$build_summary;
	}

has _node_build_summary_details => (
	is => 'lazy',
	handles_via => 'Array',
	handles => {
		_node_build_number  => [ get => 0 ],
		_node_build_details => [ get => 1 ],
	},
);
	sub _build__node_build_summary_details {
		my ($self) = @_;
		[ my ($build_number, $build_details) = $self->_node_build_summary->findnodes('./a') ];
	}

has _text_formatter => ( is => 'lazy' );
	sub _build__text_formatter {
		my $fmt_text = HTML::FormatText->new;
	}

has build_text => ( is => 'lazy' );
	sub _build_build_text {
		my ($self) = @_;
		my $bs_text = $self->_text_formatter->format($self->_node_build_summary);
		StripLTSpace($bs_text);
		$bs_text;
	}

has last_build => (
	is => 'lazy',
	handles_via => 'Hash',
	handles => {
		last_build_number  => [ get => 'number'  ],
		last_build_link    => [ get => 'link'    ],
		last_build_details => [ get => 'details' ],
		last_build_branch  => [ get => 'branch'  ],
	},
);
	sub _build_last_build {
		my ($self) = @_;
		  ($self->_node_build_number)
		? ({
				number => ( $self->_node_build_number->as_trimmed_text =~ /Build #(?<build>\d+)/ )[0] ,
				link => URI->new_abs($self->_node_build_number->attr('href'), $self->coveralls_domain),
				details => do {
					my $bd_text = $self->_node_build_details->as_trimmed_text;
					StripLTSpace($bd_text);
					$bd_text;
				},
				branch => do {
					my ($branch) = $self->_node_build_summary->findnodes('./strong');
					$branch->as_text;
				},
		  })
		: (),
	}

has _coveralls_metadata => (
	is => 'lazy',
	handles_via => 'Hash',
	handles => {
		org_name  =>  [ get => 'org_name'  ],
		org_link  =>  [ get => 'org_link'    ],
		repo_name =>  [ get => 'repo_name' ],
		repo_link  => [ get => 'repo_link'  ],
	},
);
	sub _build__coveralls_metadata {
		my ($self) = @_;
		+{
			org_name => $self->_node_coverage_org->as_trimmed_text,
			org_link => URI->new_abs($self->_node_coverage_org->attr('href'), $self->coveralls_domain),
			repo_name => $self->_node_coverage_repo->as_trimmed_text,
			repo_link => URI->new_abs($self->_node_coverage_repo->attr('href'), $self->coveralls_domain),
		},
	}

has github => ( is => 'lazy',);
	sub _build_github {
		my ($self) = @_;
		require Project::Manager::Platform::GitHub::Repo;
		Project::Manager::Platform::GitHub::Repo->new(
			namespace => $self->org_name,
			name => $self->repo_name,
		);
	}


1;
