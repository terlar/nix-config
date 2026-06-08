{ config, lib, ... }:
let
  inherit (lib) types;
  cfg = config.custom.keyboard;
in
{
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

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        console.useXkbConfig = true;

        services.kmscon.config = {
          xkb-variant = cfg.xkbVariant;
          xkb-options = cfg.xkbOptions;
        };

        services.xserver.xkb = {
          inherit (cfg) layout;
          variant = cfg.xkbVariant;
          options = cfg.xkbOptions;
        };
      }

      (lib.mkIf (cfg.xkbRepeatDelay != null) {
        services.kmscon.config.xkb-repeat-delay = cfg.xkbRepeatDelay;
        services.xserver.autoRepeatDelay = cfg.xkbRepeatDelay;
      })

      (lib.mkIf (cfg.xkbRepeatInterval != null) {
        services.kmscon.config.xkb-repeat-rate = cfg.xkbRepeatInterval;
        services.xserver.autoRepeatInterval = cfg.xkbRepeatInterval;
      })
    ]
  );
}
