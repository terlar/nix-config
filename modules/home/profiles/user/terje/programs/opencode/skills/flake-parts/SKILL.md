---
name: flake-parts
description: >
  Use when working with flake-parts — structuring flakes, defining perSystem
  outputs, writing reusable flake modules, using withSystem or moduleWithSystem,
  exporting flakeModules, or debugging flake-parts evaluation.
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
