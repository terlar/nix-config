{ ... }:

let
  desktopFile = "firefox.desktop";
in {
  programs.firefox = {
    enable = true;

    profiles.default = {
      isDefault = true;

      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };

      userChrome = ''
        ${builtins.readFile ./hide-nav-bar.css}
        ${builtins.readFile ./hide-tab-bar.css}
        ${builtins.readFile ./sidebery.css}
      '';
    };
  };

  home.sessionVariables.BROWSER = "firefox";
  xdg.mimeApps = {
    associations.added = {
      "x-scheme-handler/http" = desktopFile;
      "x-scheme-handler/https" = desktopFile;
      "x-scheme-handler/ftp" = desktopFile;
    };
  };
}
