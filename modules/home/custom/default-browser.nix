{ config, lib, ... }:
let
  inherit (lib) types;
  cfg = config.custom.defaultBrowser;
  desktopFile = builtins.head (
    builtins.attrNames (builtins.readDir "${cfg.package}/share/applications")
  );
in
{
  options.custom.defaultBrowser = {
    enable = lib.mkEnableOption "default browser configuration";

    package = lib.mkOption {
      type = types.package;
      defaultText = lib.literalExpression "pkgs.firefox";
      description = "The default browser derivation to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables.BROWSER = lib.getExe cfg.package;
    xdg.mimeApps.defaultApplications = {
      "application/xhtml+xml" = desktopFile;
      "text/html" = desktopFile;
      "text/xml" = desktopFile;
      "x-scheme-handler/ftp" = desktopFile;
      "x-scheme-handler/http" = desktopFile;
      "x-scheme-handler/https" = desktopFile;
    };
  };
}
