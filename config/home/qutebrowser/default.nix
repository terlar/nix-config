{ ... }:

{
  programs.qutebrowser = {
    enable = true;

    aliases = {
      w = "session-save";
      q = "quit";
      wq = "quit --save";
      mpv = "spawn --userscript view_in_mpv";
    };

    autoSave.session = true;

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

    content = {
      defaultEncoding = "utf-8";
      javascript.log = {
        unknown = "none";
        info = "debug";
        warning = "debug";
        error = "debug";
      };
    };

    downloads = {
      position = "bottom";
      removeFinished = 100;
    };

    editor.command = [ "emacsclient" "-c" "{}" ];

    spellcheck.languages = [ "en-US" "sv-SE" ];

    statusbar = {
      hide = true;
      padding = { top = 5; bottom = 5; left = 5; right = 5; };
    };

    tabs = {
      background = true;
      mousewheelSwitching = false;
      padding = { top = 5; bottom = 5; left = 0; right = 5; };
      position = "left";
      show = "switching";
      width = "15%";
    };

    url.searchengines = {
      DEFAULT = "https://duckduckgo.com/?q={}";
      aw = "https://wiki.archlinux.org/index.php?search={}";
      g = "https://google.com/search?q={}";
      gh = "https://github.com/search?q={}";
      h = "https://www.haskell.org/hoogle/?hoogle={}";
      hackage = "https://hackage.haskell.org/packages/search?terms={}";
      we = "https://en.wikipedia.org/w/index.php?search={}";
      ws = "https://sv.wikipedia.org/w/index.php?search={}";
    };

    extraConfig = builtins.readFile <dotfiles/qutebrowser/.config/qutebrowser/config.py> ;
  };
}
