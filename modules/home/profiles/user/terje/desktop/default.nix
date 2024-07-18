{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkDefault mkIf mkMerge;

  cfg = config.profiles.user.terje.desktop;
in
{
  options.profiles.user.terje.desktop = {
    enable = lib.mkEnableOption "desktop profile for Terje";
    enableCommunicationPackages = lib.mkEnableOption "install communication packages";
    enableMediaPackages = lib.mkEnableOption "install media packages";
  };

  config = mkIf cfg.enable {
    profiles = {
      user.terje = {
        graphical.enable = true;

        browser.brave = {
          enable = mkDefault true;
          defaultBrowser = mkDefault true;
        };
        terminal.foot = {
          enable = mkDefault true;
          defaultTerminal = mkDefault true;
        };

        desktop.gnome = {
          enable = mkDefault true;
          paperwm.enable = mkDefault true;
        };
      };
    };

    home.packages = mkMerge [
      (mkIf cfg.enableCommunicationPackages [
        pkgs.discord
        pkgs.slack
        pkgs.tdesktop
        pkgs.zoom-us
      ])

      (mkIf cfg.enableMediaPackages [
        pkgs.krita
        pkgs.spotify
      ])
    ];
  };
}
