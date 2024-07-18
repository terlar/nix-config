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
            home = {
              username = "terje";
              homeDirectory = "/home/terje";
              stateVersion = "20.09";
            };
          }
        ];
      }
    );

    packages.x86_64-linux.home-terje = config.flake.homeConfigurations.terje.activationPackage;
  };
}
