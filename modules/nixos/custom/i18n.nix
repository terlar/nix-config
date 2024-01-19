{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) types;
  cfg = config.custom.i18n;
in {
  options.custom.i18n = {
    enable = lib.mkEnableOption "internationalization customization";

    inputMethod = lib.mkOption {
      type = types.nullOr (types.enum ["ibus" "fcitx5"]);
      default = "ibus";
      description = "Input method to use.";
    };

    languages = lib.mkOption {
      type = types.listOf (types.enum ["chinese"]);
      default = [];
      description = "Used languages.";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    (lib.mkIf (cfg.inputMethod != null) {
      i18n.inputMethod.enabled = cfg.inputMethod;
    })
    (lib.mkIf (builtins.elem "chinese" cfg.languages) {
      i18n.inputMethod.ibus.engines = [pkgs.ibus-engines.libpinyin];
      i18n.inputMethod.fcitx5.addons = [pkgs.fcitx5-chinese-addons];
    })
  ]);
}
