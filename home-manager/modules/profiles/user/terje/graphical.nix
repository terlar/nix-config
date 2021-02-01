{ config, dotfiles, lib, pkgs, ... }:

with lib;

let cfg = config.profiles.user.terje.graphical;
in {
  options.profiles.user.terje.graphical = {
    enable = mkEnableOption "Graphical profile for terje";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      profiles.user.terje.base.enable = true;
      profiles.user.terje.paperwm.enable = true;
      profiles.highContrast.enable = true;

      gtk.enable = true;
    }

    # Fonts
    {
      fonts.fontconfig.enable = true;

      home.packages = with pkgs; [
        iosevka-slab
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        noto-fonts-extra
      ];
    }

    # Kitty
    {
      home.packages = [ pkgs.kitty ];

      home.sessionVariables.TERMINAL = "kitty";

      xdg = {
        configFile."kitty/kitty.conf".source =
          "${dotfiles}/kitty/.config/kitty/kitty.conf";
        configFile."kitty/diff.conf".source =
          "${dotfiles}/kitty/.config/kitty/diff.conf";
        configFile."kitty/colors-dark.conf".source =
          "${dotfiles}/kitty/.config/kitty/colors-dark.conf";
        configFile."kitty/colors-light.conf".source =
          "${dotfiles}/kitty/.config/kitty/colors-light.conf";
      };
    }

    # Packages
    {
      home.packages = with pkgs; [
        # application
        krita
        mpv
        slack
        spotify
        sxiv

        # utility
        feh
        imagemagick
      ];
    }

    # Rofi
    {
      programs.rofi = {
        enable = true;
        font = "monospace 16";
        separator = "solid";
        colors = let
          bg = "#273238";
          bgAlt = "#1e2529";
          bgHigh = "#394249";
          fg = "#c1c1c1";
          fgHigh = "#ffffff";
          fgActive = "#80cbc4";
          fgUrgent = "#ff1844";
        in {
          window = {
            background = bg;
            border = bg;
            separator = bgAlt;
          };

          rows = {
            normal = {
              foreground = fg;
              background = bg;
              backgroundAlt = bg;
              highlight = {
                foreground = fgHigh;
                background = bgHigh;
              };
            };
            active = {
              foreground = fgActive;
              background = bg;
              backgroundAlt = bg;
              highlight = {
                foreground = fgActive;
                background = bgHigh;
              };
            };
            urgent = {
              foreground = fgUrgent;
              background = bg;
              backgroundAlt = bg;
              highlight = {
                foreground = fgUrgent;
                background = bgHigh;
              };
            };
          };
        };
      };
    }

    # Qutebrowser
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

          fonts.default_family = "Iosevka Slab Light";

          spellcheck.languages = [ "en-US" "sv-SE" ];

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
            "<Space>" = "set-cmd-text -s :buffer";
            "O" = "set-cmd-text -s :open {url:pretty}";
            "T" = "set-cmd-text :open -t -r {url:pretty}";
            "gt" = "tab-next";
            "gT" = "tab-prev";
            "t" = "set-cmd-text -s :open -t";
            "xb" = "config-cycle statusbar.show always in-mode";
            "xt" = "config-cycle tabs.show multiple switching";
            "xv" = "spawn --userscript view_in_mpv";
            "xV" = "hint links spawn mpv {hint-url}";
            "xx" =
              "config-cycle statusbar.show always in-mode ;; config-cycle tabs.show multiple switching";
          };
          insert = {
            "<Alt-v>" = "fake-key <PgUp>";
            "<Ctrl-v>" = "fake-key <PgDown>";
            "<Ctrl-k>" = "fake-key <Shift-End> ;; fake-key <Delete>";
            "<Ctrl-c>'" = "open-editor";
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
  ]);
}
