{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.browsh;
in
{
  options.programs.browsh = {
    enable = lib.mkEnableOption "browsh";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.browsh;
      defaultText = lib.literalExpression "pkgs.browsh";
      description = "Package providing {command}`browsh`.";
    };

    firefoxPackage = lib.mkOption {
      type = lib.types.package;
      default = config.programs.firefox.package;
      defaultText = lib.literalExpression "config.programs.firefox.package";
      description = "Package providing {command}`firefox` needed by browsh.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      cfg.package
      cfg.firefoxPackage
    ];
  };
}
