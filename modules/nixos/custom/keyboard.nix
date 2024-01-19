{
  config,
  lib,
  ...
}: let
  inherit (lib) types;
  cfg = config.custom.keyboard;
in {
  options.custom.keyboard = {
    enable = lib.mkEnableOption "keyboard customization";

    layout = lib.mkOption {
      type = types.str;
      default = "us";
      description = "Keyboard layout, or multiple keyboard layouts separated by commas.";
    };

    xkbOptions = lib.mkOption {
      type = types.commas;
      default = "terminate:ctrl_alt_bksp";
      example = "grp:caps_toggle,grp_led:scroll";
      description = "X keyboard options; layout switching goes here.";
    };

    xkbVariant = lib.mkOption {
      type = types.str;
      default = "";
      example = "colemak";
      description = "X keyboard variant.";
    };

    xkbRepeatDelay = lib.mkOption {
      type = types.nullOr types.int;
      default = null;
      description = "Sets the autorepeat delay.";
    };

    xkbRepeatInterval = lib.mkOption {
      type = types.nullOr types.int;
      default = null;
      description = "Sets the autorepeat interval.";
    };
  };

  config = lib.mkIf cfg.enable {
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
