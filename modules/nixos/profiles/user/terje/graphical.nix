{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.profiles.user.terje.graphical;
in
{
  options.profiles.user.terje.graphical = {
    enable = lib.mkEnableOption "Graphical profile for terje";
    desktop = lib.mkEnableOption "Desktop mode";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        profiles.user.terje = {
          base.enable = true;
          fonts.enable = lib.mkDefault true;
        };

        # Graphical boot process.
        boot.plymouth.enable = true;
      }

      (lib.mkIf cfg.desktop {
        services.displayManager.gdm.enable = true;
        services.desktopManager.gnome.enable = lib.mkDefault true;

        # Scrollable-tiling Wayland compositor
        programs = {
          niri.enable = lib.mkDefault true;
          dms-shell.enable = lib.mkDefault true;
        };

        environment = {
          gnome.excludePackages = [
            pkgs.geary
          ];

          # Wayland support for Electron and Chromium
          sessionVariables.NIXOS_OZONE_WL = "1";
        };
      })
    ]
  );
}
