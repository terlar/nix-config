{ lib, ... }:

let
  inherit (lib) mkOption mkEnableOption types;

  mkIndentStyleOption =
    lang: default:
    mkOption {
      type = types.enum [
        "space"
        "tab"
      ];
      inherit default;
      description = "Indentation style for ${lang}";
    };

  mkIndentSizeOption =
    lang: default:
    mkOption {
      type = types.int;
      inherit default;
      description = "Indentation size for ${lang}";
    };
in
{
  options.profiles.development = {
    enable = mkEnableOption "development profile";

    javascript = {
      enable = mkEnableOption "JavaScript development profile";
      indentStyle = mkIndentStyleOption "JavaScript" "space";
      indentSize = mkIndentSizeOption "JavaScript" 2;
    };

    nix.enable = mkEnableOption "Nix development profile";

    plantuml = {
      indentStyle = mkIndentStyleOption "PlantUML" "space";
      indentSize = mkIndentSizeOption "PlantUML" 2;
    };

    python = {
      enable = mkEnableOption "Python development profile";
      indentStyle = mkIndentStyleOption "Python" "space";
      indentSize = mkIndentSizeOption "Python" 4;
    };

    shell = {
      enable = mkEnableOption "shell development profile";
      indentStyle = mkIndentStyleOption "Shell" "tab";
      indentSize = mkIndentSizeOption "Shell" 2;
    };
  };
}
