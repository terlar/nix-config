---
name: flake-parts
description: >
  Use when working with flake-parts or dev-flake — structuring flakes, defining
  perSystem outputs, writing reusable flake modules, using withSystem or
  moduleWithSystem, exporting flakeModules, setting up dev environments with
  dev-flake, or debugging flake-parts evaluation.
compatibility: opencode
---

## Basic structure

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

Always pass the outputs function argument as `inputs` (not `self.inputs`) to
avoid infinite recursion.

## Key options

| Option | Purpose |
|---|---|
| `systems` | List of systems to iterate over in `perSystem` |
| `perSystem` | Module evaluated once per system; receives `pkgs`, `system`, `config`, etc. |
| `flake` | System-independent flake outputs merged directly |
| `imports` | Import flake-parts modules |
| `debug` | Expose full module config in flake outputs for inspection |

## perSystem module args

| Arg | Value |
|---|---|
| `system` | Current system string (e.g., `"x86_64-linux"`) |
| `pkgs` | `nixpkgs.legacyPackages.${system}` (configurable) |
| `config` | The current perSystem module's config |
| `inputs'` | All inputs with outputs pre-selected for `system` |
| `self'` | This flake's own outputs pre-selected for `system` |

Override `pkgs` for the whole `perSystem` scope (e.g. to allow unfree):

```nix
perSystem = { system, ... }: {
  _module.args.pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
};
```

## withSystem — access per-system config from top level

Use `withSystem` to reference per-system packages from top-level module scope
(e.g. when building `nixosConfigurations`):

```nix
{ inputs, withSystem, ... }: {
  flake.nixosConfigurations.my-host = withSystem "x86_64-linux" (
    { pkgs, self', ... }:
    inputs.nixpkgs.lib.nixosSystem {
      modules = [ ./configuration.nix { nixpkgs.pkgs = pkgs; } ];
    }
  );
}
```

## moduleWithSystem — inject perSystem args into NixOS modules

Wrap a NixOS module to receive per-system args. The target system is inferred
from the module's own `pkgs` or `system` arg:

```nix
{ moduleWithSystem, ... }: {
  flake.nixosModules.my-module = moduleWithSystem (
    { pkgs, self' }:
    { config, lib, ... }: {
      environment.systemPackages = [ self'.packages.my-tool ];
    }
  );
}
```

## Exporting flake-parts modules

Expose reusable flake-parts modules under `flake.flakeModules`:

```nix
{ flake-parts-lib, lib, ... }: {
  imports = [ inputs.flake-parts.flakeModules.flakeModules ];

  flake.flakeModules.default = { ... }: {
    options.perSystem = flake-parts-lib.mkPerSystemOption {
      _file = ./flake-module.nix;  # always set for error attribution
      options.myOutput = lib.mkOption {
        type = lib.types.lazyAttrsOf lib.types.package;
        default = {};
      };
    };
  };
}
```

Dogfooding pattern — use your own module and export it:

```nix
let myModule = ./flake-module.nix;
in {
  imports = [ myModule ];
  flake.flakeModules.default = myModule;
}
```

Consumers import it as:

```nix
imports = [ inputs.my-lib.flakeModules.default ];
```

Convention: local module files are named `flake-module.nix`. Always set `_file`
on inner `mkPerSystemOption` calls for accurate error attribution.

## Importing flake-parts modules

```nix
imports = [
  inputs.some-flake.flakeModules.default
  ./flake-module.nix
];
```

## Debugging

Enable `debug = true` to expose all intermediate module config for inspection:

```nix
inputs.flake-parts.lib.mkFlake { inherit inputs; } {
  debug = true;
  # ...
}
```

Then inspect any output path:

```bash
nix eval .#debug                                              # full debug attrset
nix eval .#debug.allSystems                                   # per-system configs
nix eval .#debug.allSystems.x86_64-linux.config.packages
```

## dev-flake

`dev-flake` (`github:terlar/dev-flake`) is a flake-parts module that bundles
devshell, git-hooks-nix (pre-commit), and treefmt-nix behind a thin `dev.*`
option surface. All features default to enabled.

### What it wires up automatically

- `devShells.default` — named devshell with pre-commit installed on entry;
  `treefmt` and `pre-commit` available as shell commands
- `checks.pre-commit` — all configured pre-commit hooks as a flake check
- `checks.treefmt` — treefmt check (only when pre-commit is disabled, to avoid
  double-checking; otherwise treefmt runs through pre-commit)
- Default hooks enabled: `deadnix`, `statix`

### Top-level `dev.*` options

| Option | Default | Description |
|---|---|---|
| `dev.name` | `"project"` | Project name, used as devshell prompt |
| `dev.rootSrc` | `self.outPath` | Project root for pre-commit; set to parent `self` in sub-flakes |
| `dev.devshell.enable` | `true` | Enable devshell |
| `dev.devshell.addCommands` | `true` | Add treefmt and pre-commit to shell menu |
| `dev.pre-commit.enable` | `true` | Enable pre-commit |
| `dev.treefmt.enable` | `true` | Enable treefmt |

### Root-flake usage

```nix
{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    dev-flake = {
      url = "github:terlar/dev-flake";
      inputs.flake-parts.follows = "flake-parts";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux" ];
      imports = [ inputs.dev-flake.flakeModule ];

      dev.name = "my-project";

      perSystem = { config, pkgs, ... }: {
        # formatter is not set automatically — wire it up explicitly
        formatter = config.treefmt.programs.nixfmt.package;
        treefmt.programs.nixfmt = {
          enable = true;
          package = pkgs.nixfmt-rfc-style;
        };
      };
    };
}
```

### Sub-flake usage (recommended)

Isolate dev dependencies in `./dev/` so they don't pollute the main flake's
closure. Use flake-parts `partitions` in the root flake to wire it in.

**`./dev/flake.nix`** — inputs only, no outputs:

```nix
{
  description = "Dependencies for development purposes";
  inputs.dev-flake.url = "github:terlar/dev-flake";
  outputs = _: { };
}
```

**`./dev/flake-module.nix`**:

```nix
{ inputs, ... }: {
  imports = [ inputs.dev-flake.flakeModule ];

  dev.name = "my-project";
  # dev.rootSrc = inputs.self.outPath;  # set if self points to ./dev, not root

  perSystem = { config, pkgs, ... }: {
    formatter = config.treefmt.programs.nixfmt.package;
    treefmt.programs.nixfmt = {
      enable = true;
      package = pkgs.nixfmt-rfc-style;
    };
  };
}
```

**Root `flake.nix`** — wire in via partitions:

```nix
imports = [ inputs.flake-parts.flakeModules.partitions ];
partitionedAttrs = {
  checks = "dev";
  devShells = "dev";
};
partitions.dev = {
  extraInputsFlake = ./dev;
  module.imports = [ ./dev/flake-module.nix ];
};
```

### Extending defaults

All underlying options from devshell, git-hooks-nix, and treefmt-nix remain
fully accessible:

```nix
perSystem = { ... }: {
  pre-commit.settings.hooks.conform.enable = true;
  treefmt.programs.mdsh.enable = true;
};
```
