{
  self,
  inputs,
  ...
}: {
  flake.nixosModules = let
    modules = self.lib.importDirToAttrs ../../nixos/modules;
  in
    {
      default = {
        imports = builtins.attrValues modules;
      };

      nixpkgs-useFlakeNixpkgs = {
        nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
        nix.registry.nixpkgs.flake = inputs.nixpkgs;
      };

      home-manager-integration = {
        config.home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = "bak";
        };
      };
    }
    // modules;
}
