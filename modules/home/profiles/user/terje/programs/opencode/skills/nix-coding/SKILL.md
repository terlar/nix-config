---
name: nix-coding
description: >
  Use when writing, editing, or reviewing Nix code — including NixOS modules,
  Home Manager configuration, flakes, packages, and overlays. Covers Nix coding
  style, module system patterns, common lib functions, flake-parts, and tooling
  conventions (nixfmt, deadnix, statix).
compatibility: opencode
---

## Style

- Prefer functional programming style; apply eta reduction where it improves
  clarity (e.g., `map f xs` not `map (x: f x) xs`).
- Use `lib.pipe` to express sequential transformations instead of nested calls:
  ```nix
  lib.pipe value [
    lib.flatten
    (map toString)
    (lib.concatStringsSep " ")
  ]
  ```
- Prefer `lib` functions over builtins when an equivalent exists
  (e.g., `lib.attrNames` over `builtins.attrNames`).
- Use `let inherit (x) a b c; in` to reduce repetition when pulling multiple
  names from the same attrset.
- Always bind `cfg = config.<module-path>;` at the top of a module's `let`
  block and reference it throughout.

## Module system patterns

```nix
{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.my.module;
in
{
  options.my.module = {
    enable = mkEnableOption "my module";
    package = mkOption {
      type = types.package;
      default = pkgs.my-package;
      description = "Package to use.";
    };
  };

  config = mkIf cfg.enable {
    # ...
  };
}
```

Key functions:

| Function | Purpose |
|---|---|
| `mkEnableOption "desc"` | Standard boolean option, default `false` |
| `mkOption { type; default; description; }` | Declare a typed option |
| `mkIf condition config` | Conditional config block |
| `mkMerge [ cfg1 cfg2 ]` | Merge multiple config blocks |
| `mkDefault value` | Set a value at low priority (overridable) |
| `mkOverride priority value` | Set priority explicitly (100 = default) |
| `mkForce value` | Set at priority 50 (overrides mkDefault) |

For submodules:
```nix
type = types.submodule {
  options = {
    foo = mkOption { type = types.str; };
  };
};
```

Look up unfamiliar `lib` functions with `@nixpkgs-lib` — browse
`lib/attrsets.nix`, `lib/lists.nix`, `lib/strings.nix`, `lib/modules.nix`,
`lib/trivial.nix`, etc.

## Common lib idioms

```nix
# Conditional list elements
lib.optionals condition [ "a" "b" ]
lib.optional condition "a"

# attrset manipulation
lib.filterAttrs (k: v: v != null) attrs
lib.mapAttrs (k: v: transform v) attrs
lib.mapAttrsToList (k: v: "${k}=${v}") attrs

# String operations
lib.concatStringsSep ", " list
lib.concatMapStringsSep "\n" f list
lib.replaceStrings [ "old" ] [ "new" ] str

# Path helpers
lib.escapeShellArg str
lib.getExe pkg  # shorthand for "${pkg}/bin/${lib.getName pkg}"
```

## Tooling

Tools are not guaranteed to be installed. Use `,` (comma) to run them without
installing — `, nixfmt`, `, deadnix`, `, statix` etc.

### nixfmt

nixfmt is the **official, opinionated Nix formatter** — no configuration.
Always run it on new or modified `.nix` files before committing.

```bash
, nixfmt file.nix        # format in place
, nixfmt < input.nix     # format from stdin
```

Key formatting rules nixfmt enforces:
- 2-space indentation
- Spaces around `=` in bindings
- Function arguments on separate lines when they don't fit on one line
- Trailing newline
- No trailing whitespace

### deadnix

deadnix removes unused bindings and function arguments.

```bash
, deadnix -e file.nix    # edit in place, removing dead code
, deadnix file.nix       # check only, print dead code
```

### statix

statix is a linter that catches Nix antipatterns.

```bash
, statix check file.nix  # report antipatterns
, statix fix file.nix    # auto-fix antipatterns where possible
```

Common patterns statix flags: unnecessary `with`, `rec` when not needed,
`builtins.*` when a `lib` equivalent exists, `map (x: f x)` instead of `map f`.

## flake-parts

flake-parts structures flakes using the NixOS module system, enabling
composable, well-typed flake outputs.

### Basic structure

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];

    perSystem = { pkgs, ... }: {
      packages.default = pkgs.hello;
      devShells.default = pkgs.mkShell { packages = [ pkgs.hello ]; };
    };

    flake = {
      # System-independent outputs (nixosConfigurations, lib, etc.)
    };
  };
}
```

### Key options

| Option | Purpose |
|---|---|
| `systems` | List of systems to iterate over in `perSystem` |
| `perSystem` | Module evaluated once per system; receives `pkgs`, `system`, `config`, etc. |
| `flake` | System-independent flake outputs merged directly |
| `imports` | Import flake-parts modules (e.g., `flake-parts` contrib modules) |

### Debugging

Enable `debug = true` to expose all intermediate module config for inspection:

```nix
inputs.flake-parts.lib.mkFlake { inherit inputs; } {
  debug = true;
  # ...
}
```

Then inspect any output path:

```bash
nix eval .#debug                        # full debug attrset
nix eval .#debug.allSystems             # per-system module configs
nix eval .#debug.allSystems.x86_64-linux.config.packages
```

### perSystem module args

`perSystem` receives these special args:

| Arg | Value |
|---|---|
| `system` | Current system string (e.g., `"x86_64-linux"`) |
| `pkgs` | `nixpkgs.legacyPackages.${system}` (or configured pkgs) |
| `config` | The current perSystem module's config |
| `inputs'` | `inputs` with each input's outputs pre-selected for `system` |
| `self'` | `self.packages.${system}` etc. pre-selected |

### Importing flake-parts modules

```nix
imports = [
  inputs.some-flake.flakeModules.default
  ./nix/devshell.nix   # local perSystem or flake module
];
```
