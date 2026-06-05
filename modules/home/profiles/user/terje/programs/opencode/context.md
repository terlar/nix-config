# Nix and System Constraints

- System is NixOS with flakes — treat all configuration as declarative.
- Do not edit system files directly; change configuration by editing declarative files.
- Use `nix shell`, `nix run`, or `,` to obtain tools without installing them.
- `,` (comma) is a wrapper that runs commands by looking them up in nixpkgs — e.g. `, jaq` runs jaq without installing it.
- Prefer `jaq` over `jq` for JSON processing.
- Use `nix-locate` to find packages; do NOT run `find` on `/nix/store`.

# Secrets

- Never decrypt or open secret files.
- Never run `sops`, `age`, or any secret-decrypting command.
- Do not open `.env` files or reveal secret contents.
- You may note that secrets exist without exposing values.

# Hacks

- When you have to write a hack for a limitation in a library, keep it away from the main logic and clearly marked.
- Encapsulate hacks in a clearly named function or module, e.g. `workaroundForX`.
- Inline a hack only if it is extremely short and self-contained.
- Mark every hack with a `HACK:` comment including: why it exists, a link to the issue or PR if available, and a TODO with a removal condition.

# Comments

- Explain **why** code exists, assumptions, and trade-offs.
- Do not write comments that restate the code.
- Preserve existing comments unless explicitly asked to remove them.
- Keep comments concise and factual.

# Hardcoded Values and Constants

- Prefer a single source of truth for configuration.
- Extract a value to a named constant if it is reused or represents a domain concept.
- Inline truly one-off values at the use site.

# Function Decomposition

- Prefer clear, well-named functions.
- Decompose when a block is reusable, improves readability, or enables testing.
- Avoid excessive micro-functions that obscure control flow.

# PR and Issue Inference

- If "the PR/issue" or "the current PR/issue" is used with no number, infer it from the current branch name using the GitHub CLI.
- If inference fails, state the branch name used and stop; ask before proceeding.

# Environment and Remote Targets

- Confirm whether the target environment is local or remote before searching for services or installing software.
- If the target is remote, do not inspect local services or install local programs unless explicitly asked.
- Ask which environment the code will run in when it is not obvious.

# Pre-commit Hooks and CI

- Run pre-commit hooks before committing.
- Fix issues reported by pre-commit locally; do not bypass or disable hooks.
- Ensure CI passes before requesting review.
- Add tests for behaviour changes when feasible.

# Idempotency and Destructive Operations

- Prefer idempotent scripts and operations.
- Avoid destructive operations without explicit confirmation.
- Require explicit approval for any destructive change: data deletion, irreversible migrations, force-pushes to shared branches.
- Provide a rollback plan for destructive changes.

# Testing and Quality

- Add unit tests for new logic and bug fixes.
- Add regression tests for fixed bugs.
- Place tests according to repository conventions.
- Run linters and formatters locally before committing.
