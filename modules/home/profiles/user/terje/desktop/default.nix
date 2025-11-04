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

    features = {
      bar = lib.mkEnableOption "desktop feature bar";
      inputMethod = lib.mkEnableOption "desktop feature Input Method Editor";
      notification = lib.mkEnableOption "desktop feature notification";
      screenLock = lib.mkEnableOption "desktop feature screen lock";
    };
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

        inputMethods.fcitx5.enable = lib.mkDefault cfg.features.inputMethod;
        programs = {
          swaylock.enable = lib.mkDefault cfg.features.screenLock;
          waybar.enable = lib.mkDefault cfg.features.bar;
        };
        services = {
          fnott.enable = lib.mkDefault cfg.features.notification;
          swayidle.enable = lib.mkDefault cfg.features.screenLock;
        };
      };
    };

    home.packages = mkMerge [
      [
        pkgs.wl-clipboard
      ]

      (mkIf cfg.enableCommunicationPackages [
        pkgs.discord
        pkgs.slack
        pkgs.telegram-desktop
        pkgs.zoom-us
      ])

      (mkIf cfg.enableMediaPackages [
        pkgs.krita
        pkgs.spotify
      ])
    ];
  };
}
