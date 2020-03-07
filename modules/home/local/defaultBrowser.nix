{ config, lib, pkgs, ... }:

with builtins;
with lib;

let
  cfg = config.local.defaultBrowser;
  bin = head (filter
    (n: match "^\\..*" n == null)
    (attrNames (readDir "${cfg.package}/bin")));
  desktopFile = head (attrNames (readDir "${cfg.package}/share/applications"));
in {
  options.local.defaultBrowser = {
    enable = mkEnableOption "default browser configuration";

    package = mkOption {
      type = types.package;
      defaultText = literalExample "pkgs.firefox";
      description = ''
        The default browser derivation to use.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.sessionVariables.BROWSER = bin;
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
