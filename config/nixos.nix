{ config, pkgs, ... }:

{
  imports = [ ./common.nix ];

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.consoleKeyMap = "us";

  fonts = {
    fontconfig.enable = true;
    fontconfig.dpi = 180;
    fonts = import ./fonts.nix { inherit pkgs; };
  };
}
