{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.custom.keyboard;

  layoutType = types.submodule {
    options = {
      layout = mkOption {
        type = types.str;
        example = "us";
        description = "Keyboard layout.";
      };

      variant = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "dvorak";
        description = "Selects a specific layout variant available for the layout.";
      };
    };
  };
in {
  options.custom.keyboard = {
    enable = mkEnableOption "keyboard customization";

    layouts = mkOption {
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

    xkbOptions = mkOption {
      type = types.listOf types.str;
      default = [];
      example = ["grp:caps_toggle" "grp_led:scroll"];
      description = "X keyboard options; layout switching goes here.";
    };

    repeatDelay = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = "Sets the autorepeat delay.";
    };

    repeatInterval = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = "Sets the autorepeat interval.";
    };
  };

  config = mkIf cfg.enable {
    dconf.settings = with hm.gvariant; {
      "org/gnome/settings-daemon/plugins/keyboard".active = true;
      "org/gnome/desktop/input-sources" = {
        xkb-options = cfg.xkbOptions;
        sources =
          map
          (x:
            mkTuple [
              "xkb"
              "${x.layout}${optionalString (x.variant != null) "+${x.variant}"}"
            ])
          cfg.layouts;
      };

      "org/gnome/desktop/peripherals/keyboard" =
        optionalAttrs (cfg.repeatDelay != null) {delay = cfg.repeatDelay;}
        // optionalAttrs (cfg.repeatInterval != null) {repeat-interval = cfg.repeatInterval;};
    };

    wayland.windowManager.sway.config.input."type:keyboard" =
      optionalAttrs (cfg.layouts != [])
      {
        xkb_layout = concatMapStringsSep "," (x: x.layout) cfg.layouts;
        xkb_variant = concatMapStringsSep "," (x: toString x.variant) cfg.layouts;
      }
      // optionalAttrs (cfg.xkbOptions != []) {xkb_options = concatStringsSep "," cfg.xkbOptions;}
      // optionalAttrs (cfg.repeatDelay != null) {repeat_delay = toString cfg.repeatDelay;}
      // optionalAttrs (cfg.repeatInterval != null) {repeat_rate = toString cfg.repeatInterval;};
  };
}
