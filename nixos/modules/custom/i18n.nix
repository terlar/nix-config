{ config, lib, pkgs, ... }:

with builtins;
with lib;

let cfg = config.custom.i18n;
in {
  options.custom.i18n = {
    enable = mkEnableOption "internationalization customization";

    inputMethod = mkOption {
      type = types.nullOr (types.enum [ "ibus" "fcitx" ]);
      default = "ibus";
      description = "Input method to use.";
    };

    languages = mkOption {
      type = types.listOf (types.enum [ "chinese" ]);
      default = [];
      description = "Used languages.";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf (cfg.inputMethod != null) {
      i18n.inputMethod.enabled = cfg.inputMethod;
    })
    (mkIf (elem "chinese" cfg.languages) {
      i18n.inputMethod.ibus.engines = with pkgs.ibus-engines; [ libpinyin ];
      i18n.inputMethod.fcitx.engines = with pkgs.fcitx-engines; [ libpinyin ];
    })
  ]);
}
