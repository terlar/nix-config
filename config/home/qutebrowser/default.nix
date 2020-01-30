{ ... }:

let
  desktopFile = "org.qutebrowser.qutebrowser.desktop";
in {
  home.sessionVariables.BROWSER = "qutebrowser";
  xdg = {
    configFile."qutebrowser/config.py".source = <dotfiles/qutebrowser/.config/qutebrowser/config.py> ;

    mimeApps = {
      associations.added = {
        "x-scheme-handler/http" = desktopFile;
        "x-scheme-handler/https" = desktopFile;
        "x-scheme-handler/ftp" = desktopFile;
      };
    };
  };
}
