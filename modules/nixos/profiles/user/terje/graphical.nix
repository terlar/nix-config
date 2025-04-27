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

  config = lib.mkIf cfg.enable {
    profiles.user.terje = {
      base.enable = true;
      fonts.enable = lib.mkDefault true;
    };

    # Graphical boot process.
    boot.plymouth.enable = true;

    services.xserver = lib.mkIf cfg.desktop {
      enable = true;

      # Display manager
      displayManager.gdm.enable = true;

      # Desktop manager
      desktopManager.gnome.enable = true;
    };

    # Scrollable-tiling Wayland compositor
    programs.niri.enable = lib.mkDefault true;

    environment = {
      gnome.excludePackages = [
        pkgs.geary
      ];

      # Wayland support for Electron and Chromium
      sessionVariables.NIXOS_OZONE_WL = "1";
    };
  };
}
