{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.installer-yubikey = {
      imports = [
        "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-base.nix"
        ../../nixos/installer/yubikey
      ];
    };
    nixosConfigurations.installer-yubikey = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [self.nixosModules.installer-yubikey];
    };

    packages.x86_64-linux.yubikeyInstallerImage = self.nixosConfigurations.installer-yubikey.config.system.build.isoImage;
  };
}
