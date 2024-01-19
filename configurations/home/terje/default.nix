{
  config,
  inputs,
  withSystem,
  ...
}: let
  system = "x86_64-linux";
in {
  flake = {
    homeConfigurations.terje = withSystem system ({pkgs, ...}:
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          config.flake.homeModules.user-terje-linux
          {
            home.username = "terje";
            home.homeDirectory = "/home/terje";
            profiles.user.terje.graphical.enable = true;
          }
        ];
      });

    packages.${system}.home-terje = config.flake.homeConfigurations.terje.activationPackage;
  };
}
