{ config, lib, ... }:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    mkMerge
    types
    ;

  cfg = config.profiles.user.terje.browser.qutebrowser;
  desktopFile = "org.qutebrowser.qutebrowser.desktop";
in
{
  options.profiles.user.terje.browser.qutebrowser = {
    enable = mkEnableOption "Qutebrowser browser configuration for Terje";
    defaultBrowser = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to configure {command}`qutebrowser` as the default
        browser using the {env}`BROWSER` environment variable and mime default applications config.
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs.qutebrowser = {
        enable = true;

        aliases = {
          mpv = "spawn --userscript view_in_mpv";
          q = "quit";
          w = "session-save";
          wq = "quit --save";
        };

        searchEngines = {
          DEFAULT = "https://duckduckgo.com/?q={}";
          aw = "https://wiki.archlinux.org/index.php?search={}";
          g = "https://google.com/search?q={}";
          gh = "https://github.com/search?q={}";
          h = "https://www.haskell.org/hoogle/?hoogle={}";
          hackage = "https://hackage.haskell.org/packages/search?tberms={}";
          we = "https://en.wikipedia.org/w/index.php?search={}";
          ws = "https://sv.wikipedia.org/w/index.php?search={}";
        };

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

          fonts.default_family = "Iosevka Curly Slab Light";

          spellcheck.languages = [
            "en-US"
            "sv-SE"
          ];

          statusbar.show = "in-mode";

          tabs = {
            background = true;
            mousewheel_switching = false;
            position = "left";
            show = "switching";
            width = "15%";
          };
        };

        keyBindings = {
          normal = {
            "<Alt-9>" = "tab-focus 9";
            "<Alt-0>" = "tab-focus -1";
            "<Space>" = "set-cmd-text -s :tab-select";
            "O" = "set-cmd-text -s :open {url:pretty}";
            "T" = "set-cmd-text :open -t -r {url:pretty}";
            "gt" = "tab-next";
            "gT" = "tab-prev";
            "t" = "set-cmd-text -s :open -t";
            "xb" = "config-cycle statusbar.show always in-mode";
            "xt" = "config-cycle tabs.show multiple switching";
            "xv" = "spawn --userscript view_in_mpv";
            "xV" = "hint links spawn mpv {hint-url}";
            "xx" = "config-cycle statusbar.show always in-mode ;; config-cycle tabs.show multiple switching";
          };
          insert = {
            "<Alt-v>" = "fake-key <PgUp>";
            "<Ctrl-v>" = "fake-key <PgDown>";
            "<Ctrl-k>" = "fake-key <Shift-End> ;; fake-key <Delete>";
            "<Ctrl-c>'" = "edit-text";
            "<Ctrl-i>" = "inspector";
          };
        };

        keyMappings = {
          "<Alt-b>" = "<Alt-Left>";
          "<Alt-d>" = "<Alt-Delete>";
          "<Alt-f>" = "<Alt-Right>";
          "<Ctrl-6>" = "<Ctrl-^>";
          "<Ctrl-Enter>" = "<Ctrl-Return>";
          "<Ctrl-[>" = "<Escape>";
          "<Ctrl-a>" = "<Home>";
          "<Ctrl-b>" = "<Left>";
          "<Ctrl-d>" = "<Delete>";
          "<Ctrl-e>" = "<End>";
          "<Ctrl-f>" = "<Right>";
          "<Ctrl-g>" = "<Escape>";
          "<Ctrl-j>" = "<Return>";
          "<Ctrl-m>" = "<Return>";
          "<Ctrl-n>" = "<Down>";
          "<Ctrl-p>" = "<Up>";
          "<Enter>" = "<Return>";
          "<Shift-Enter>" = "<Return>";
          "<Shift-Return>" = "<Return>";
        };

        extraConfig = ''
          # Appearance
          c.statusbar.padding['bottom'] = 5
          c.statusbar.padding['left'] = 5
          c.statusbar.padding['right'] = 5
          c.statusbar.padding['top'] = 5
          c.tabs.padding['bottom'] = 5
          c.tabs.padding['left'] = 0
          c.tabs.padding['right'] = 5
          c.tabs.padding['top'] = 5

          # Other
          c.content.javascript.log['error'] = 'debug'
          c.content.javascript.log['info'] = 'debug'
          c.content.javascript.log['unknown'] = 'none'
          c.content.javascript.log['warning'] = 'debug'
        '';
      };
    }

    (mkIf cfg.defaultBrowser {
      home.sessionVariables.BROWSER = lib.getExe config.programs.qutebrowser.package;
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
