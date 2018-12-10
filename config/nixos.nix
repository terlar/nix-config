{ config, pkgs, ... }:

{
  imports = [ ./common.nix ];

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.consoleKeyMap = "us";

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;

    fonts = import ./fonts.nix { inherit pkgs; };

    fontconfig = {
      enable = true;
      dpi = 180;
      defaultFonts = {
        monospace = [ "Iosevka Slab" ];
        sansSerif = [ "Noto Sans" ];
        serif     = [ "Noto Serif" ];
      };
    };
  };
}
