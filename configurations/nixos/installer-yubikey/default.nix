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
            overlays = [
              (_final: prev: {
                inherit (config.flake.packages.${prev.stdenv.hostPlatform.system})
                  drduh-gpg-conf
                  drduh-yubikey-guide
                  ;
              })
            ];
          };
        }
      ];
    };

    packages.x86_64-linux.yubikeyInstallerImage =
      config.flake.nixosConfigurations.installer-yubikey.config.system.build.isoImage;
  };
}
