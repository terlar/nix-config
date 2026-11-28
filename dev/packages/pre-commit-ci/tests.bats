setup() {
  export mockdir=$(mktemp -d)

  # Source SUT to define main function
  source "$SUT"

  # Mock called commands via shell functions (take precedence over PATH)
  prek() { echo "prek $*" >> "$mockdir/called"; }
  git() { true; }
  export -f prek git

  export mockdir
}

teardown() {
  rm -rf "$mockdir"
}

verify_called() {
  local expected="$1"
  local actual
  actual=$(cat "$mockdir/called" 2>/dev/null || true)
  if ! echo "$actual" | grep -Fx "$expected" >/dev/null 2>&1; then
    echo "# FAIL: expected '$expected', got: '$actual'" >&3
    return 1
  fi
}

@test "manual trigger runs --all-files" {
  GITHUB_ACTIONS='' run main
  verify_called "prek run -c $PRE_COMMIT_CONFIG --all-files"
}

@test "GitHub PR compares to target branch" {
  GITHUB_ACTIONS=true GITHUB_BASE_REF=main run main
  verify_called "prek run -c $PRE_COMMIT_CONFIG --from-ref origin/main --to-ref HEAD --show-diff-on-failure"
}

@test "GitHub branch push compares to before SHA" {
  GITHUB_ACTIONS=true GITHUB_EVENT_BEFORE=abc123 run main
  verify_called "prek run -c $PRE_COMMIT_CONFIG --from-ref abc123 --to-ref HEAD --show-diff-on-failure"
}

@test "GitHub new branch push (zero before SHA) runs --all-files" {
  GITHUB_ACTIONS=true GITHUB_EVENT_BEFORE=0000000000000000000000000000000000000000 run main
  verify_called "prek run -c $PRE_COMMIT_CONFIG --all-files --show-diff-on-failure"
}
