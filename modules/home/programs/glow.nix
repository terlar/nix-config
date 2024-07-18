{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.glow;

  jsonFormat = pkgs.formats.json { };
  yamlFormat = pkgs.formats.yaml { };
in
{
  options.programs.glow = {
    enable = lib.mkEnableOption "glow";

    package = lib.mkPackageOption pkgs "glow" { };

    settings = lib.mkOption {
      type = lib.types.submodule { freeformType = yamlFormat.type; };
      default = { };
      example = lib.literalExpression ''
        {
          pager = true;
        };
      '';
      description = "Configuration written to {file}`$XDG_CONFIG_HOME/glow/glow.yml`.";
    };

    style = lib.mkOption {
      type = lib.types.submodule { freeformType = jsonFormat.type; };
      default = { };
      example = lib.literalExpression ''
        {
          document = {
            block_prefix = "\n";
            block_suffix = "\n";
            margin = 2;
          };
        };
      '';
      description = "Auto-generated style file referred to by {file}`$XDG_CONFIG_HOME/glow/glow.yml`.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    programs.glow.settings = lib.mkIf (cfg.style != { }) {
      style = jsonFormat.generate "glow-style-${config.home.username}" cfg.style;
    };

    xdg.configFile."glow/glow.yml" = lib.mkIf (cfg.settings != { }) {
      source = yamlFormat.generate "glow-config-${config.home.username}" cfg.settings;
    };
  };
}
