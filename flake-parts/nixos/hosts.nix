{
  lib,
  self,
  inputs,
  ...
}: {
  flake = lib.mkMerge [
    {
      nixosConfigurations.chameleon = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          self.nixosModules.default
          self.nixosModules.nixpkgs-useFlakeNixpkgs
          self.nixosModules.home-manager-integration

          inputs.nixpkgs.nixosModules.notDetected
          inputs.nixos-hardware.nixosModules.common-cpu-intel
          inputs.nixos-hardware.nixosModules.common-pc-laptop
          inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
          inputs.home-manager.nixosModules.home-manager
          inputs.nixos-wsl.nixosModules.wsl

          ../../nixos/hosts/chameleon

          {
            nixpkgs.overlays = builtins.attrValues self.overlays;
            nixpkgs.config.allowUnfree = true;

            home-manager = {
              sharedModules = [self.homeManagerModules.user-terje];
            };
          }
        ];
      };
    }

    {
      nixosConfigurations.kong = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          self.nixosModules.default
          self.nixosModules.nixpkgs-useFlakeNixpkgs
          self.nixosModules.home-manager-integration

          inputs.nixpkgs.nixosModules.notDetected
          inputs.nixos-hardware.nixosModules.dell-xps-15-9560-intel
          inputs.nixos-hardware.nixosModules.common-pc-laptop
          inputs.nixos-hardware.nixosModules.common-pc-ssd
          inputs.home-manager.nixosModules.home-manager

          ../../nixos/hosts/kong

          {
            nixpkgs.overlays = builtins.attrValues self.overlays;
            nixpkgs.config.allowUnfree = true;

            home-manager = {
              sharedModules = [self.homeManagerModules.user-terje];
            };
          }
        ];
      };
    }

    {
      nixosModules.host-snail = {
        imports = [
          inputs.nixos-hardware.nixosModules.raspberry-pi-4
          ../../nixos/hosts/snail
        ];
      };
    }
  ];
}
