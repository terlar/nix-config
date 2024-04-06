{
  lib,
  flake-parts-lib,
  self,
  ...
}:
let
  inherit (lib) mkOption types;
  inherit (flake-parts-lib) mkSubmoduleOptions;
in
{
  options = {
    flake = mkSubmoduleOptions {
      homeModules = mkOption {
        type = types.lazyAttrsOf types.unspecified;
        default = { };
        apply = lib.mapAttrs (
          k: v: {
            _file = "${toString self.outPath}/flake.nix#homeModules.${k}";
            imports = [ v ];
          }
        );
        description = ''
          Home Manager modules.

          You may use this for reusable pieces of configuration, service modules, etc.
        '';
      };

      homeConfigurations = mkOption {
        type = types.lazyAttrsOf types.raw;
        default = { };
        description = ''
          Instantiated Home Manager configurations. Used by `home-manager`.

          `homeConfigurations` is for specific users. If you want to expose
          reusable configurations, add them to [`homeModules`](#opt-flake.homeModules)
          in the form of modules (no `lib.homeManagerConfiguration`), so that you can reference
          them in this or another flake's `homeConfigurations`.
        '';
        example = lib.literalExpression ''
          {
            my-user = withSystem "x86_64-linux" ({pkgs, ...}:):
              inputs.home-manager.lib.homeManagerConfiguration {
                inherit pkgs;
                modules = [
                  ./my-user/home-configuration.nix
                  config.homeModules.my-module
                ];
              };
          }
        '';
      };
    };
  };
}
