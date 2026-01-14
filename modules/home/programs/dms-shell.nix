{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.dms-shell;

  jsonFormat = pkgs.formats.json { };
in
{
  options.programs.dms-shell = {
    enable = lib.mkEnableOption "dms-shell";

    package = lib.mkPackageOption pkgs "dms-shell" { };

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
      source = jsonFormat.generate "dms-config-${config.home.username}" cfg.settings;
    };
  };
}
