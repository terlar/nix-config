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
    enable = lib.mkEnableOption "graphical profile for Terje";
  };

  config = lib.mkIf cfg.enable {
    profiles = {
      highContrast.enable = lib.mkDefault true;
      user.terje.graphical.fonts.enable = lib.mkDefault true;
    };

    gtk.enable = lib.mkDefault true;

    home.packages = [
      pkgs.eog
      pkgs.mpv
    ];

    # Fix GTK4 gtk.css complaining about being overwritten.
    xdg.configFile."gtk-4.0/gtk.css".force = true;
  };
}
