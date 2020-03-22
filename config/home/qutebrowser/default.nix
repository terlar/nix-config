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
    session.lazyRestore = true;

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

    extraConfig = ''
      # Emacs bindings
      c.bindings.commands = {
          'insert': {
              '<Alt-v>'   : 'fake-key <PgUp>',
              '<Ctrl-v>'  : 'fake-key <PgDown>',
              '<Ctrl-k>'  : 'fake-key <Shift-End> ;; fake-key <Delete>',
              "<Ctrl-c>'" : 'open-editor',
              '<Ctrl-i>'  : 'inspector',
          }
      }

      ## Bindings for normal mode
      config.bind('<Alt-9>', 'tab-focus 9')
      config.bind('<Alt-0>', 'tab-focus -1')
      config.bind('<Space>', 'set-cmd-text -s :buffer')
      config.bind('O', 'set-cmd-text -s :open {url:pretty}')
      config.bind('T', 'set-cmd-text :open -t -r {url:pretty}')
      config.bind('gt', 'tab-next')
      config.bind('gT', 'tab-prev')
      config.bind('t', 'set-cmd-text -s :open -t')
      config.bind('xb', 'config-cycle statusbar.hide')
      config.bind('xt', 'config-cycle tabs.show multiple switching')
      config.bind('xv', 'spawn --userscript view_in_mpv')
      config.bind('xV', 'hint links spawn mpv {hint-url}')
      config.bind('xx', 'config-cycle statusbar.hide ;; config-cycle tabs.show multiple switching')
    '';
  };
}
