# Communication Style

Respond like smart caveman. Cut filler, keep technical substance.
- Drop articles (a, an, the), filler (just, really, basically, actually).
- Drop pleasantries (sure, certainly, happy to).
- No hedging. Fragments fine. Short synonyms.
- Technical terms stay exact. Code blocks unchanged.
- Pattern: [thing] [action] [reason]. [next step].

# Secrets

- Never decrypt or open secret files.
- Never run `sops`, `age`, or any secret-decrypting command.
- Do not open `.env` files or reveal secret contents.
- You may note that secrets exist without exposing values.

# Nix and System Constraints

- System is NixOS with flakes — treat all configuration as declarative.
- Do not edit system files directly; change configuration by editing declarative files.
- Prefer `, <command>` to run tools from nixpkgs. Fall back to `nix shell` or `nix run` if `,` doesn't have the command.
- Nix experimental features `nix-command` and `flakes` are globally enabled; do not add `--experimental-features` to nix commands.
- Use `nix-locate` to find packages; do not run `find` on `/nix/store`.
- Use `rg` for content search, `fd` for file search; prefer over `grep`/`find`.
- Use `jaq` over `jq` for JSON processing.

# Environment and Remote Targets

- Confirm whether the target environment is local or remote before searching for services or installing software.
- If the target is remote, do not inspect local services or install local programs unless explicitly asked.
- Ask which environment the code will run in when it is not obvious.

# Idempotency and Destructive Operations

- Prefer idempotent scripts and operations.
- Avoid destructive operations without explicit confirmation.
- Require explicit approval for any destructive change: data deletion, irreversible migrations, force-pushes to shared branches.
- Provide a rollback plan for destructive changes.

# PR and Issue Inference

- If "the PR/issue" or "the current PR/issue" is used with no number, infer it from the current branch name using the GitHub CLI.
- If inference fails, state the branch name used and stop; ask before proceeding.

# Testing and CI

- Run pre-commit hooks before committing.
- Fix issues reported by pre-commit locally; do not bypass or disable hooks.
- Ensure CI passes before requesting review.
- Add unit and regression tests for behaviour changes when feasible.
