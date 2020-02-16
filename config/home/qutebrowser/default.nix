{ ... }:

let
  desktopFile = "org.qutebrowser.qutebrowser.desktop";
in {
  home.sessionVariables.BROWSER = "qutebrowser";

  programs.qutebrowser = {
    enable = true;
    extraConfig = builtins.readFile <dotfiles/qutebrowser/.config/qutebrowser/config.py> ;
  };

  xdg = {
    mimeApps = {
      associations.added = {
        "x-scheme-handler/http" = desktopFile;
        "x-scheme-handler/https" = desktopFile;
        "x-scheme-handler/ftp" = desktopFile;
      };
      defaultApplications = {
        "x-scheme-handler/http" = desktopFile;
        "x-scheme-handler/https" = desktopFile;
        "x-scheme-handler/ftp" = desktopFile;
      };
    };
  };
}
