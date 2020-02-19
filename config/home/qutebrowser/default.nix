{ ... }:

let
  desktopFile = "org.qutebrowser.qutebrowser.desktop";
in {
  home.sessionVariables.BROWSER = "qutebrowser";

  programs.qutebrowser = {
    enable = true;

    aliases = {
      w = "session-save";
      q = "quit";
      wq = "quit --save";
      mpv = "spawn --userscript view_in_mpv";
    };

    bindings.keyMappings = {
      "<Ctrl-g>" = "<Escape>";
      "<Ctrl-[>" = "<Escape>";
      "<Ctrl-6>" = "<Ctrl-^>";
      "<Ctrl-m>" = "<Return>";
      "<Ctrl-j>" = "<Return>";
      "<Shift-Return>" = "<Return>";
      "<Enter>" = "<Return>";
      "<Shift-Enter>" = "<Return>";
      "<Ctrl-Enter>" = "<Ctrl-Return>";
      "<Ctrl-f>" = "<Right>";
      "<Ctrl-b>" = "<Left>";
      "<Ctrl-a>" = "<Home>";
      "<Ctrl-e>" = "<End>";
      "<Ctrl-n>" = "<Down>";
      "<Ctrl-p>" = "<Up>";
      "<Alt-f>" = "<Alt-Right>";
      "<Alt-b>" = "<Alt-Left>";
      "<Ctrl-d>" = "<Delete>";
      "<Alt-d>" = "<Alt-Delete>";
    };

    colors = {
      statusbar = {
        command.bg = "#263238";
        normal.bg = "#263238";
      };
      tabs = {
        selected.even.bg = "#263238";
        selected.odd.bg = "#263238";
      };
    };

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
