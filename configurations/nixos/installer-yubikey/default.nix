{ config, inputs, ... }:
{
  flake = {
    nixosConfigurations.installer-yubikey = inputs.nixpkgs.lib.nixosSystem {
      modules = [
        "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-base.nix"
        ./configuration.nix

        {
          nixpkgs = {
            hostPlatform = "x86_64-linux";
            overlays = [ config.flake.overlays.default ];
          };
        }
      ];
    };

    packages.x86_64-linux.yubikeyInstallerImage =
      config.flake.nixosConfigurations.installer-yubikey.config.system.build.isoImage;
  };
}
