{
  config,
  inputs,
  withSystem,
  ...
}:
{
  flake = {
    homeConfigurations.terje = withSystem "x86_64-linux" (
      { pkgs, ... }:
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
      }
    );

    packages.x86_64-linux.home-terje = config.flake.homeConfigurations.terje.activationPackage;
  };
}
