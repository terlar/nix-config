{ config, lib, pkgs, ... }:

{
  services.kmscon = {
    enable = true;
    hwRender = true;
    extraConfig = "
      palette=solarized-white
      font-name=Fira Mono
      font-size=20
      xkb-variant=altgr-intl
      xkb-options=lv3:ralt_switch,ctrl:nocaps
      xkb-repeat-delay=200
      xkb-repeat-rate=25
    ";
  };
}
