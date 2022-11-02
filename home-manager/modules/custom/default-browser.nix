{
  config,
  lib,
  ...
}:
with builtins;
with lib; let
  cfg = config.custom.defaultBrowser;
  bin = pipe "${getBin cfg.package}/bin" [
    readDir
    attrNames
    (filter (n: match "^\\..*" n == null))
    head
  ];
  desktopFile = head (attrNames (readDir "${cfg.package}/share/applications"));
in {
  options.custom.defaultBrowser = {
    enable = mkEnableOption "default browser configuration";

    package = mkOption {
      type = types.package;
      defaultText = literalExpression "pkgs.firefox";
      description = "The default browser derivation to use.";
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
