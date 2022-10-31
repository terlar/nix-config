{
  lib,
  self,
  inputs,
  ...
}: {
  flake.homeManagerModules = let
    modules = self.lib.importDirToAttrs ../../home-manager/modules;
  in
    {
      default = {
        imports = builtins.attrValues modules;
      };

      nixpkgs-useFlakeNixpkgs = {
        home.sessionVariables.NIX_PATH = "nixpkgs=${inputs.nixpkgs}";
        systemd.user.sessionVariables.NIX_PATH = lib.mkForce "nixpkgs=${inputs.nixpkgs}";
        nix.registry.nixpkgs.flake = inputs.nixpkgs;
      };
    }
    // modules;
}
