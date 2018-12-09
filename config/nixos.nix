{ config, pkgs, ... }:

{
  imports = [ ./common.nix ];

  fonts = {
    fontconfig.enable = true;
    fontconfig.dpi = 180;
    fonts = import ./fonts.nix { inherit pkgs; };
  };
}
