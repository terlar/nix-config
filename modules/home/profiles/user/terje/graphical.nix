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
        profiles = {
          highContrast.enable = lib.mkDefault true;
          user.terje = {
            base.enable = true;
            fonts.enable = lib.mkDefault true;
          };
        };

        gtk.enable = true;

        home.packages = [
          pkgs.gnome.eog
          pkgs.mpv
        ];
      }

      (lib.mkIf cfg.desktop {
        profiles = {
          user.terje = {
            browser.enable = lib.mkDefault true;
            terminal.enable = lib.mkDefault cfg.desktop;
            gnome = {
              enable = lib.mkDefault true;
              paperwm.enable = lib.mkDefault true;
            };
          };
        };

        home.packages = [
          pkgs.krita
          pkgs.spotify

          pkgs.discord
          pkgs.slack
          pkgs.tdesktop
          pkgs.zoom-us
        ];
      })
    ]
  );
}
