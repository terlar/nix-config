#!/usr/bin/env bash
# Regenerate the workflow after Renovate updates action pins in dev/ci.nix.
set -euo pipefail

bundle="$(nix build --no-link --print-out-paths .#ci-pipelines-github-actions)"
nix shell --inputs-from . nixpkgs#yq-go --command yq \
  --prettyPrint --output-format yaml "$bundle/default.yml" \
  > .github/workflows/ci.yml
