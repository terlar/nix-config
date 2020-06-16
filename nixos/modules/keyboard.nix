{ config, lib, pkgs, ... }:

with lib;

let cfg = config.custom.keyboard;
in {
  options.custom.keyboard = {
    enable = mkEnableOption "keyboard customization";

    layout = mkOption {
      type = types.str;
      default = "us";
      description =
        "Keyboard layout, or multiple keyboard layouts separated by commas.";
    };

    xkbOptions = mkOption {
      type = types.commas;
      default = "terminate:ctrl_alt_bksp";
      example = "grp:caps_toggle,grp_led:scroll";
      description = "X keyboard options; layout switching goes here.";
    };

    xkbVariant = mkOption {
      type = types.str;
      default = "";
      example = "colemak";
      description = "X keyboard variant.";
    };

    xkbRepeatDelay = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = "Sets the autorepeat delay.";
    };

    xkbRepeatInterval = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = "Sets the autorepeat interval.";
    };
  };

  config = mkIf cfg.enable {
    console.useXkbConfig = true;

    services.kmscon = {
      extraConfig = ''
        xkb-variant=${cfg.xkbVariant}
        xkb-options=${cfg.xkbOptions}
        xkb-repeat-delay=${toString cfg.xkbRepeatDelay}
        xkb-repeat-rate=${toString cfg.xkbRepeatInterval}
      '';
    };

    services.xserver = {
      inherit (cfg) layout xkbOptions xkbVariant;
      autoRepeatDelay = cfg.xkbRepeatDelay;
      autoRepeatInterval = cfg.xkbRepeatInterval;
    };
  };
}
