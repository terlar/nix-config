{
  lib,
  flake-parts-lib,
  self,
  ...
}: let
  inherit
    (lib)
    mkOption
    types
    ;
  inherit (flake-parts-lib) mkSubmoduleOptions;
in {
  imports = [./modules.nix ./users.nix];

  options = {
    flake = mkSubmoduleOptions {
      homeManagerModules = mkOption {
        type = types.lazyAttrsOf types.unspecified;
        default = {};
        apply = lib.mapAttrs (k: v: {
          _file = "${toString self.outPath}/flake.nix#homeManagerModules.${k}";
          imports = [v];
        });
        description = ''
          Home Manager modules.
        '';
      };
    };
  };
}
