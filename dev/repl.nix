{
  system ? builtins.currentSystem,
}:
let
  self = builtins.getFlake (toString ../.);
  flakeModule = self.inputs.flake-parts.lib.evalFlakeModule { inherit (self) inputs; } { };
  inputs' = builtins.mapAttrs (_: flakeModule.config.perInput system) self.inputs;
  config = flakeModule.config.perInput system self;

  inherit (self.inputs.nixpkgs) lib;
in
self
// config
// {
  inherit
    config
    lib
    self
    system
    ;
  inputs = lib.fold lib.recursiveUpdate { } [
    self.inputs
    inputs'
  ];
  b = builtins;
  pkgs = import self.inputs.nixpkgs {
    inherit system;
    overlays = builtins.attrValues self.overlays;
  };
}
