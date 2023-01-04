{
  config,
  dotfiles,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.profiles.user.terje.graphical;
in {
  options.profiles.user.terje.graphical = {
    enable = mkEnableOption "Graphical profile for terje";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      profiles.user.terje.base.enable = true;
      profiles.user.terje.gnome.enable = true;
      profiles.user.terje.gnome.paperwm.enable = true;
      profiles.highContrast.enable = true;

      gtk.enable = true;

      custom.defaultBrowser = {
        enable = true;
        package = pkgs.qutebrowser;
      };
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

    # Foot
    {
      programs.foot = {
        enable = true;
        server.enable = true;
        settings = {
          main = {
            font = "Iosevka Slab Light:size=10";
          };

          scrollback = {
            lines = 1000000;
          };

          mouse = {
            hide-when-typing = "yes";
          };

          search-bindings = {
            delete-next = "Control+d Delete";
          };

          colors = {
            foreground = "002b37";
            background = "fffce9";
            regular0 = "002b37"; # black
            regular1 = "bb3e06"; # red
            regular2 = "596e76"; # green
            regular3 = "98a6a6"; # yellow
            regular4 = "596e76"; # blue
            regular5 = "596e76"; # magenta
            regular6 = "596e76"; # cyan
            regular7 = "98a6a6"; # white
            bright0 = "596e76"; # bright black
            bright1 = "cc1f24"; # bright red
            bright2 = "002b37"; # bright green
            bright3 = "596e76"; # bright yellow
            bright4 = "002b37"; # bright blue
            bright5 = "002b37"; # bright magenta
            bright6 = "002b37"; # bright cyan
            bright7 = "f4eedb"; # bright white
          };
        };
      };
    }

    # Kitty
    {
      home.packages = [pkgs.kitty];

      home.sessionVariables.TERMINAL = "kitty";

      xdg = {
        configFile."kitty/kitty.conf".source = "${dotfiles}/kitty/.config/kitty/kitty.conf";
        configFile."kitty/diff.conf".source = "${dotfiles}/kitty/.config/kitty/diff.conf";
        configFile."kitty/colors-dark.conf".source = "${dotfiles}/kitty/.config/kitty/colors-dark.conf";
        configFile."kitty/colors-light.conf".source = "${dotfiles}/kitty/.config/kitty/colors-light.conf";
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
      };
    }

    # Firefox
    {
      programs.firefox = {
        enable = true;
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

          spellcheck.languages = ["en-US" "sv-SE"];

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
  ]);
}
