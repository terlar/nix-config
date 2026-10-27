{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.dux-shell;

  jsonFormat = pkgs.formats.json { };
in
{
  options.programs.dux-shell = {
    enable = lib.mkEnableOption "dux-shell";

    package = lib.mkPackageOption pkgs "dux-shell" { };

    settings = lib.mkOption {
      inherit (jsonFormat) type;
      default = { };
      example = lib.literalExpression ''
        {
          showCpuTemp = true;
        };
      '';
      description = "Configuration written to {file}`$XDG_CONFIG_HOME/DankMaterialShell/settings.json`.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."DankMaterialShell/settings.json" = lib.mkIf (cfg.settings != { }) {
      source = jsonFormat.generate "dux-config-${config.home.username}" cfg.settings;
    };
  };
}
