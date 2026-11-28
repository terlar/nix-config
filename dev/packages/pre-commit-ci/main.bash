main() {
	local from_ref=""

	if [[ -n ${GITHUB_ACTIONS:-} ]]; then
		>&2 echo "Running on GitHub Actions"
		before_sha="${GITHUB_EVENT_BEFORE:-}"
		target_ref="${GITHUB_BASE_REF:-}"
	else
		>&2 echo "Manual trigger, running hooks on all files"
		prek run -c "$PRE_COMMIT_CONFIG" --all-files
		exit $?
	fi

	# from...to diff needs a merge base, absent in shallow checkouts.
	if [[ $(git rev-parse --is-shallow-repository) == true ]]; then
		git fetch --unshallow --quiet origin
	fi

	if [[ -n ${target_ref:-} ]]; then
		>&2 echo "Pull request pipeline, comparing to target branch: $target_ref"
		git fetch origin "$target_ref"
		from_ref="origin/$target_ref"
	elif [[ -n ${before_sha:-} && ! ${before_sha} =~ ^0+$ ]]; then
		>&2 echo "Branch pipeline, comparing to previous commit: $before_sha"
		git fetch origin "$before_sha" HEAD
		from_ref="$before_sha"
	else
		>&2 echo "No previous commit, running hooks on all files"
		prek run -c "$PRE_COMMIT_CONFIG" --all-files --show-diff-on-failure
		exit $?
	fi

	prek run -c "$PRE_COMMIT_CONFIG" --from-ref "$from_ref" --to-ref HEAD --show-diff-on-failure
}

if [[ ${BASH_SOURCE[0]} == "${0}" ]]; then
	main "$@"
fi
