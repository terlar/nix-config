{ config, lib, ... }:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    types
    ;

  cfg = config.profiles.user.terje.browser.brave;
  desktopFile = "brave-browser.desktop";
in
{
  options.profiles.user.terje.browser.brave = {
    enable = mkEnableOption "Brave browser configuration for Terje";
    defaultBrowser = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to configure {command}`brave` as the default
        browser using the {env}`BROWSER` environment variable and mime default applications config.
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs.brave = {
        enable = true;
      };
    }

    (mkIf cfg.defaultBrowser {
      home.sessionVariables.BROWSER = lib.getExe config.programs.brave.package;
      xdg.mimeApps.defaultApplications = {
        "application/xhtml+xml" = desktopFile;
        "text/html" = desktopFile;
        "text/xml" = desktopFile;
        "x-scheme-handler/ftp" = desktopFile;
        "x-scheme-handler/http" = desktopFile;
        "x-scheme-handler/https" = desktopFile;
      };
    })
  ]);
}
