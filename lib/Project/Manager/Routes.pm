package Project::Manager::Routes;

use Modern::Perl;

sub show_all_repo_list {
	# show all repos that belong to a given user
	# git hub repos <account>
	# @orgs = git hub orgs <account> --raw
	# git hub repos @orgs
}

sub show_all_activity {
}

sub show_ns_feed {
}

sub show_ns_repo_list {
	# git hub repos <namespace>
}

sub show_repo_info {
	# git hub repo <namespace/repo>
}

sub show_repo_feed {
	...
}

sub show_repo_issue_list {
	...
}

sub show_repo_issue {
	...
}

sub show_repo_pull_list {
	# git hub pr-list
	...
}

sub show_repo_pull {
	# git hub pr-list
	...
}

sub show_repo_issue_and_pull_list {
	...
}


1;
