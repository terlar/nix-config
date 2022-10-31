{system ? builtins.currentSystem}: let
  self = builtins.getFlake (toString ./.);
  flakeModule = self.inputs.flake-parts.lib.evalFlakeModule {inherit self;} {};
  inputs' = builtins.mapAttrs (k: flakeModule.config.perInput system) self.inputs;
  self' = flakeModule.config.perInput system self;

  inherit (self.inputs.nixpkgs) lib;
in
  self
  // self'
  // {
    inherit lib self system;
    inputs = lib.fold lib.recursiveUpdate {} [self.inputs inputs'];
    b = builtins;
    pkgs = import self.inputs.nixpkgs {
      inherit system;
      overlays = builtins.attrValues self.overlays;
    };
  }
