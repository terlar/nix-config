{ config, inputs, ... }:
{
  flake.nixosConfigurations.kong = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      config.flake.nixosModules.default
      config.flake.nixosModules.homeManagerIntegration

      inputs.nixpkgs.nixosModules.notDetected
      inputs.nixos-hardware.nixosModules.dell-xps-15-9560
      inputs.nixos-hardware.nixosModules.common-pc-laptop
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      inputs.nix-index-database.nixosModules.nix-index
      inputs.home-manager.nixosModules.home-manager

      {
        nixpkgs.overlays = builtins.attrValues config.flake.overlays;
        nixpkgs.config.allowUnfree = true;

        home-manager = {
          sharedModules = [ config.flake.homeModules.user-terje ];
        };
      }

      ./configuration.nix
      ./hardware-configuration.nix
    ];
  };
}
