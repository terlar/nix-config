{
  lib,
  self,
  inputs,
  withSystem,
  ...
}: {
  flake = {
    homeManagerModules.user-terje = {
      imports = [
        self.homeManagerModules.default
        self.homeManagerModules.nixpkgs-useFlakeNixpkgs
        inputs.emacs-config.homeManagerModules.emacsConfig
      ];

      _module.args = {inherit (inputs) dotfiles;};
    };

    homeManagerModules.user-terje-linux = {
      imports = [self.homeManagerModules.user-terje];

      targets.genericLinux.enable = true;

      # FIXME: Temporary hack until nixpkgs.config.allowUnfree works in Home Manager
      # flake integration (lib.homeManagerConfiguration).
      nixpkgs.config.allowUnfreePredicate = lib.const true;
      nixpkgs.overlays = builtins.attrValues self.overlays;
    };

    homeConfigurations.terje = withSystem "x86_64-linux" ({pkgs, ...}:
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          self.homeManagerModules.user-terje-linux
          {
            home.username = "terje";
            home.homeDirectory = "/home/terje";
            profiles.user.terje.graphical.enable = true;
          }
        ];
      });
  };

  perSystem = {pkgs, ...}: let
    activationPackages = builtins.mapAttrs (_: lib.getAttr "activationPackage") self.homeConfigurations;
  in {
    packages = lib.pipe activationPackages [
      (lib.filterAttrs (_: drv: pkgs.system == drv.system))
      (lib.mapAttrs' (username: drv: lib.nameValuePair "home-${username}" drv))
    ];
  };
}
