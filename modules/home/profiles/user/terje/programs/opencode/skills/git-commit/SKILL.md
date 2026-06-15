---
name: git-commit
description: >
  Use this skill whenever the user wants to commit changes, stage files, write
  a commit message, or run git commit — even if they just say "commit this",
  "save my changes", or "make a commit". Guides writing well-structured commit
  messages following the Conventional Commits specification, enforcing scope
  rules from .conform.yaml, protecting main/master branches, and ensuring clean
  staging hygiene before every commit.
compatibility: opencode
---

## Branching rules

- **Check current branch:** Always determine the current branch (e.g.,
  `git branch --show-current`) before writing or executing a commit.
- **Protect main/master:** If the current branch is `main` or `master`,
  **halt and explicitly ask the user for permission** before proceeding with
  the commit.
- **Prefer feature branches:** When asked to commit on `main` or `master`,
  actively suggest creating a new feature branch (e.g.,
  `git checkout -b <type>/<brief-description>`) as the preferred alternative.

## Commit message structure

```
<type>(<optional scope>): <description>

[optional body]

[optional footer]
```

## Types

Use exactly one of: `build`, `chore`, `ci`, `docs`, `feat`, `fix`, `perf`,
`refactor`, `style`, `test`

- `feat` - adds a new feature
- `fix` - fixes a bug
- All other types - use the one that best describes the change

## Subject line rules

- Type and description are required; scope is optional
- Description must immediately follow the type/scope prefix
- Write in imperative mood: `add`, `fix`, `update`, `remove`, `rename`
- Limit description to 72 characters unless `.conform.yaml`
  specifies different limits — check it first
- Lowercase the entire subject line
- Do not end with punctuation
- ASCII only: no emojis, em dashes, or other non-standard characters

## Scope rules

**Always check `.conform.yaml` first** (if present in the repo root):

- If `conventional.scopes` is defined, **only use scopes from that list**
- If the change doesn't fit any existing scope, **ask the user** whether to
  add a new scope; if they agree, add it to `.conform.yaml` before committing
- If `header.length` or `descriptionLength` are set, use those limits
- If no `.conform.yaml` exists, use the name of the most directly affected
  component: module name, directory, or logical area
- Omit scope when a change is genuinely cross-cutting

## Body rules

- Leave one blank line between subject and body
- Use bullet points starting with `- `
- Capitalise the first letter of each bullet point
- Write each bullet in imperative mood
- Keep bullet points short and clear
- ASCII only: no emojis, em dashes, or other non-standard characters
- Omit the body entirely if it adds no useful detail beyond the subject

## Breaking changes

- Append `!` to the type/scope for breaking changes: `feat!:` or
  `feat(scope)!:`
- Add a `BREAKING CHANGE: <description>` footer separated from the body by a
  blank line
- The footer must describe what breaks and how to migrate

## Atomicity

- Each commit must represent one logical change
- If unrelated changes are present in the working tree, split them into
  separate commits before staging

## Staging hygiene

Before writing the commit message:

1. Stage only files that were explicitly changed during the session; never
   stage unrelated pre-existing modifications
2. Avoid `git add .` or `git add -A` unless every change in the working tree
   is intentional and part of this commit
3. Run `git diff --staged` and confirm the staged diff matches the intended
   change before proceeding

## Rebase rules

- Always pass `--committer-date-is-author-date` when rebasing — this preserves
  the original author date so history isn't rewritten with the rebase timestamp

## GPG signing failures

- If `git commit` fails with "Bad PIN" from the GPG agent, retry the commit
  immediately. The "Bad PIN" error typically means a mistyped passphrase; a
  retry will prompt for the passphrase again.
- Do not change the commit message or staging between retries — reuse the
  exact same commit command.
- If retry fails again with "Bad PIN", ask the user to unlock their GPG key
  first (e.g., `gpg --card-status` or `echo test | gpg --sign`) before
  retrying the commit.

## Examples

Good subject lines:

```
feat(opencode): add declarative skills support
fix(shell): correct PATH ordering for homebrew on darwin
chore(deps): update flake inputs
refactor(home): extract keymap definitions into separate file
```

Good commit with body:

```
feat(opencode): add declarative skills support

- Add skills.enable toggle for built-in skills bundled with the config
- Add skills.extraSkillsDirs for external skill directories
- Deploy each skill to ~/.config/opencode/skills/<name>/SKILL.md
- Use last-writer-wins on name collision to allow overrides
```

Breaking change commit:

```
feat(api)!: remove legacy configuration format

- Drop support for the v1 config schema
- Require migration to the v2 format before upgrading

BREAKING CHANGE: v1 config files are no longer read; run
`migrate-config` to convert them to v2 format before upgrading.
```

Body-less commit (body would add no value):

```
chore(deps): update flake inputs
```
