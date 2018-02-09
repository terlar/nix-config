{ config, pkgs, ... }:

let
  xkbVariant     = "altgr-intl";
  xkbOptions     = "lv3:ralt_switch,ctrl:nocaps";
  repeatDelay    = 200;
  repeatInterval = 33; # 30Hz
in
{
  services.xserver = {
    xkbVariant = xkbVariant;
    xkbOptions = xkbOptions;

    autoRepeatDelay = repeatDelay;
    autoRepeatInterval = repeatInterval;
  };

  services.kmscon.extraConfig = ''
    xkb-variant=${xkbVariant}
    xkb-options=${xkbOptions}
    xkb-repeat-delay=${toString repeatDelay}
    xkb-repeat-rate=${toString repeatInterval}
  '';
}
