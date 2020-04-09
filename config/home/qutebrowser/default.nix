{ ... }:

{
  programs.qutebrowser = {
    enable = true;

    settings = {
      auto_save.session = true;
      session.lazy_restore = true;

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

      content.default_encoding = "utf-8";

      downloads = {
        position = "bottom";
        remove_finished = 100;
      };

      editor.command = [ "emacsclient" "-c" "{}" ];

      spellcheck.languages = [ "en-US" "sv-SE" ];

      statusbar.hide = true;

      tabs = {
        background = true;
        mousewheel_switching = false;
        position = "left";
        show = "switching";
        width = "15%";
      };
    };

    extraConfig = ''
      c.aliases = {
          'mpv': 'spawn --userscript view_in_mpv',
          'q': 'quit',
          'w': 'session-save',
          'wq': 'quit --save'
      }

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

      c.bindings.key_mappings = {
          '<Alt-b>': '<Alt-Left>',
          '<Alt-d>': '<Alt-Delete>',
          '<Alt-f>': '<Alt-Right>',
          '<Ctrl-6>': '<Ctrl-^>',
          '<Ctrl-Enter>': '<Ctrl-Return>',
          '<Ctrl-[>': '<Escape>',
          '<Ctrl-a>': '<Home>',
          '<Ctrl-b>': '<Left>',
          '<Ctrl-d>': '<Delete>',
          '<Ctrl-e>': '<End>',
          '<Ctrl-f>': '<Right>',
          '<Ctrl-g>': '<Escape>',
          '<Ctrl-j>': '<Return>',
          '<Ctrl-m>': '<Return>',
          '<Ctrl-n>': '<Down>',
          '<Ctrl-p>': '<Up>',
          '<Enter>': '<Return>',
          '<Shift-Enter>': '<Return>',
          '<Shift-Return>': '<Return>'
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

      # Appearance
      c.statusbar.padding = {
          'bottom': 5,
          'left': 5,
          'right': 5,
          'top': 5
      }
      c.tabs.padding = {
          'bottom': 5,
          'left': 0,
          'right': 5,
          'top': 5
      }

      # Other
      c.content.javascript.log = {
          'error': 'debug',
          'info': 'debug',
          'unknown': 'none',
          'warning': 'debug'
      }

      c.url.searchengines = {
          'DEFAULT': 'https://duckduckgo.com/?q={}',
          'aw': 'https://wiki.archlinux.org/index.php?search={}',
          'g': 'https://google.com/search?q={}',
          'gh': 'https://github.com/search?q={}',
          'h': 'https://www.haskell.org/hoogle/?hoogle={}',
          'hackage': 'https://hackage.haskell.org/packages/search?terms={}',
          'we': 'https://en.wikipedia.org/w/index.php?search={}',
          'ws': 'https://sv.wikipedia.org/w/index.php?search={}'
      }
    '';
  };
}
