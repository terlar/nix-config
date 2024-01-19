{
  config,
  lib,
  ...
}: let
  inherit (lib) types;
  cfg = config.custom.keyboard;

  layoutType = types.submodule {
    options = {
      layout = lib.mkOption {
        type = types.str;
        example = "us";
        description = "Keyboard layout.";
      };

      variant = lib.mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "dvorak";
        description = "Selects a specific layout variant available for the layout.";
      };
    };
  };
in {
  options.custom.keyboard = {
    enable = lib.mkEnableOption "keyboard customization";

    layouts = lib.mkOption {
      type = types.listOf layoutType;
      default = [{layout = "us";}];
      example = [
        {layout = "us";}
        {
          layout = "us";
          variant = "dvorak";
        }
      ];
      description = "Keyboard layouts";
    };

    xkbOptions = lib.mkOption {
      type = types.listOf types.str;
      default = [];
      example = ["grp:caps_toggle" "grp_led:scroll"];
      description = "X keyboard options; layout switching goes here.";
    };

    repeatDelay = lib.mkOption {
      type = types.nullOr types.int;
      default = null;
      description = "Sets the autorepeat delay.";
    };

    repeatInterval = lib.mkOption {
      type = types.nullOr types.int;
      default = null;
      description = "Sets the autorepeat interval.";
    };
  };

  config = lib.mkIf cfg.enable {
    dconf.settings = {
      "org/gnome/settings-daemon/plugins/keyboard".active = true;
      "org/gnome/desktop/input-sources" = {
        xkb-options = cfg.xkbOptions;
        sources =
          map
          (x:
            lib.hm.gvariant.mkTuple [
              "xkb"
              "${x.layout}${lib.optionalString (x.variant != null) "+${x.variant}"}"
            ])
          cfg.layouts;
      };

      "org/gnome/desktop/peripherals/keyboard" =
        lib.optionalAttrs (cfg.repeatDelay != null) {delay = cfg.repeatDelay;}
        // lib.optionalAttrs (cfg.repeatInterval != null) {repeat-interval = cfg.repeatInterval;};
    };

    wayland.windowManager.sway.config.input."type:keyboard" =
      lib.optionalAttrs (cfg.layouts != [])
      {
        xkb_layout = lib.concatMapStringsSep "," (x: x.layout) cfg.layouts;
        xkb_variant = lib.concatMapStringsSep "," (x: toString x.variant) cfg.layouts;
      }
      // lib.optionalAttrs (cfg.xkbOptions != []) {xkb_options = builtins.concatStringsSep "," cfg.xkbOptions;}
      // lib.optionalAttrs (cfg.repeatDelay != null) {repeat_delay = toString cfg.repeatDelay;}
      // lib.optionalAttrs (cfg.repeatInterval != null) {repeat_rate = toString cfg.repeatInterval;};
  };
}
