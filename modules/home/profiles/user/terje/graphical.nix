{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.profiles.user.terje.graphical;
in {
  options.profiles.user.terje.graphical = {
    enable = lib.mkEnableOption "Graphical profile for terje";
    desktop = lib.mkEnableOption "Desktop mode";
  };

  config = lib.mkIf cfg.enable {
    profiles = {
      highContrast.enable = lib.mkDefault true;
      user.terje = {
        base.enable = true;
        browser.enable = lib.mkDefault true;
        fonts.enable = lib.mkDefault true;
        terminal.enable = lib.mkDefault true;
        gnome = {
          enable = lib.mkDefault true;
          paperwm.enable = lib.mkDefault true;
        };
      };
    };

    gtk.enable = true;

    home.packages =
      [
        pkgs.mpv
        pkgs.sxiv
      ]
      ++ lib.optionals cfg.desktop [
        pkgs.krita
        pkgs.slack
        pkgs.spotify
        pkgs.tdesktop
        pkgs.zoom-us
      ];
  };
}
