---
name: nix-coding
description: >
  Use when writing, editing, or reviewing Nix code — including NixOS modules,
  Home Manager configuration, packages, and overlays. Covers Nix coding style,
  module system patterns, common lib functions, and tooling (nixfmt, deadnix,
  statix). For flake-parts-specific patterns use the flake-parts skill instead.
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

## Module decomposition

Split large modules across files by concern:

- `interface.nix` — options declarations only, no `config`
- `default.nix` — `imports` list + top-level wiring, minimal logic
- Backend/feature files — each contributes only `config` for their concern

```
my-module/
  interface.nix        # options only
  default.nix          # imports + orchestration
  feature-a.nix        # config for feature A
  feature-b.nix        # config for feature B
```

`default.nix` acts as an orchestration point with zero business logic:

```nix
{ lib, config, ... }:
{
  imports = [
    ./interface.nix
    ./feature-a.nix
    ./feature-b.nix
  ];
  config._module.args.my-lib = import ./lib { inherit lib; };
}
```

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
| `mkBefore [ … ]` | Prepend to a list (priority 500) |
| `mkAfter [ … ]` | Append to a list (priority 1500) |
| `mkOrder n [ … ]` | Insert at explicit list priority |

### Overriding mkEnableOption defaults

Override just the `default` field without rewriting the whole option:

```nix
enable = (lib.mkEnableOption "my feature") // { default = true; };
```

### Conditional config with mkIf + mkDefault

Gate a value with `mkIf`, use `mkDefault` inside so users can still override:

```nix
config.my.option = lib.mkIf condition (lib.mkDefault computedValue);
```

### mkMerge list of mkIf blocks

Prefer a flat list of conditional blocks over deeply nested if-else:

```nix
config.github-actions = lib.mkMerge [
  { runs-on = "ubuntu-latest"; steps = baseSteps; }
  (lib.mkIf cfg.checkout { steps = lib.mkBefore [{ uses = "actions/checkout@v4"; }]; })
  (lib.mkIf (cfg.env != { }) { env = cfg.env; })
];
```

### apply — normalise at definition time

Use `apply` to canonicalise a value whenever the option is set:

```nix
jobs = lib.mkOption {
  type = lib.types.listOf lib.types.str;
  apply = lib.unique;  # deduplicate automatically
};

needs = lib.mkOption {
  apply = lib.pipe [
    lib.flatten
    lib.unique
    (builtins.filter (n: n != config.name))  # remove self-references
  ];
};
```

### Advanced option types

| Type | When to use |
|---|---|
| `types.lazyAttrsOf t` | Attrsets of submodules — avoids evaluating all values upfront |
| `types.functionTo t` | Expose a configurable strategy/transform function as an option |
| `types.deferredModule` | Store a module for deferred/separate evaluation |
| `types.submoduleWith { modules; specialArgs; shorthandOnlyDefinesConfig; }` | Submodule with extra args or shorthand support |

```nix
# lazyAttrsOf — prefer over attrsOf for submodule attrsets
jobs = lib.mkOption {
  type = lib.types.lazyAttrsOf (lib.types.submoduleWith { modules = [ ./job ]; });
};

# functionTo — expose a configurable transform
formatName = lib.mkOption {
  type = lib.types.functionTo lib.types.str;
  default = lib.concatStringsSep "-";
};

# shorthandOnlyDefinesConfig — let callers use bare attrsets
type = lib.types.submoduleWith {
  modules = [ ./item ];
  shorthandOnlyDefinesConfig = true;
};
```

### _module.args — inject shared libraries

Inject a shared library at the module root so all submodules receive it as a
regular function argument without needing import paths:

```nix
# In the root module:
config._module.args.my-lib = import ./lib { inherit lib; };

# In any submodule:
{ my-lib, config, lib, ... }: {
  config.result = my-lib.transform config.value;
}
```

### _module.freeformType — escape hatch for unknown fields

Allow arbitrary fields while still validating known options:

```nix
config._module.freeformType = lib.types.attrsOf lib.types.anything;
```

### Internal options

Mark computed/implementation-detail options with `internal = true` to hide
them from documentation:

```nix
_computed = lib.mkOption {
  internal = true;
  type = lib.types.package;
  default = lib.pipe config.documents [ … ];
};
```

### specialArgs — pass parent config into submodules

Pass a parent's `config` into child submodules via `specialArgs`:

```nix
type = lib.types.submoduleWith {
  modules = [ ./child ];
  specialArgs.parentConfig = config;  # accessible as a function arg in child
};
```

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

# Conditional attrset assembly — prefer over chained // operators
lib.mergeAttrsList [
  { always = "present"; }
  (lib.optionalAttrs condition { extra = "field"; })
  (lib.optionalAttrs other { another = "field"; })
]

# attrset manipulation
lib.filterAttrs (k: v: v != null) attrs
lib.mapAttrs (k: v: transform v) attrs
lib.mapAttrsToList (k: v: "${k}=${v}") attrs
lib.genAttrs [ "a" "b" ] (name: "value-${name}")

# List operations
lib.concatMap f list     # map then flatten one level
lib.unique list          # deduplicate
lib.flatten list         # flatten arbitrarily nested list

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

