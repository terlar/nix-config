{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.profiles.user.terje.gnome;
in {
  options.profiles.user.terje.gnome = {
    enable = mkEnableOption "GNOME profile for terje";

    materialShell = {enable = mkEnableOption "Use Material Shell";};
    paperwm = {
      enable = mkEnableOption "Use PaperWM";
      package = mkOption {
        type = types.package;
        default = pkgs.gnomeExtensions.paperwm;
        example = literalExpression "pkgs.gnomeExtensions.paperwm";
        description = ''
          Package providing PaperWM extension.
        '';
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      profiles.gnome.enable = true;

      services.gnome-keyring = {
        enable = true;
        components = ["pkcs11" "secrets"];
      };

      programs.gnome-shell = {
        enable = true;
        extensions = [
          {package = pkgs.gnomeExtensions.true-color-invert;}
          {package = pkgs.gnomeExtensions.miniview;}
        ];
      };

      dconf.settings = {
        "org/gnome/desktop/wm/keybindings" = {
          activate-window-menu = [];
          hide-window = [];
          restore-window = [];
          switch-applications = [];
          switch-applications-backward = [];
        };

        "org/gnome/settings-daemon/plugins/media-keys" = {
          screensaver = ["<Super>q"];
        };

        "org/gnome/shell/extensions/miniview" = {
          showme = false;
        };

        "org/gnome/shell/extensions/true-color-invert" = {
          invert-window-shortcut = ["<Super>exclam"];
        };

        "org/freedesktop/ibus/panel/emoji" = {
          unicode-hotkey = [];
        };
      };
    }

    (mkIf cfg.materialShell.enable {
      programs.gnome-shell = {
        extensions = [
          {package = pkgs.gnomeExtensions.material-shell;}
        ];
      };
    })

    (mkIf cfg.paperwm.enable {
      programs.gnome-shell = {
        extensions = [
          {inherit (cfg.paperwm) package;}
          {package = pkgs.gnomeExtensions.unite;}
          {package = pkgs.gnomeExtensions.cleaner-overview;}
          {package = pkgs.gnomeExtensions.vertical-overview;}
        ];
      };

      dconf.settings = with lib.hm.gvariant; {
        "org/gnome/mutter" = {
          attach-modal-dialogs = false;
          edge-tiling = false;
          workspaces-only-on-primary = false;
        };

        "org/gnome/shell/extensions/paperwm" = {
          animation-time = 0.1;
          minimap-scale = 0.0;
          show-window-position-bar = false;
          use-default-background = false;

          horizontal-margin = 0;
          vertical-margin = 0;
          vertical-margin-bottom = 4;
          window-gap = 8;
        };

        "org/gnome/shell/extensions/paperwm/keybindings" = {
          new-window = ["<Super>Return"];
          close-window = ["<Super>BackSpace"];

          toggle-scratch = ["<Shift><Super>s"];
          toggle-scratch-layer = ["<Super>s"];

          slurp-in = ["<Super>i"];
          barf-out = ["<Super>o"];

          previous-workspace = ["<Super>Tab"];
          move-previous-workspace = ["<Control><Super>Tab"];
          previous-workspace-backward = ["<Shift><Super>Tab"];
          move-previous-workspace-backward = ["<Control><Shift><Super>Tab"];

          switch-first = ["<Super>Home"];
          switch-last = ["<Super>End"];

          switch-left = ["<Super>h"];
          move-left = ["<Shift><Super>comma" "<Shift><Super>h"];

          switch-right = ["<Super>l"];
          move-right = ["<Shift><Super>period" "<Shift><Super>l"];

          switch-previous = ["<Super>comma" "<Super>k"];
          move-up = ["<Shift><Super>k"];

          switch-next = ["<Super>period" "<Super>j"];
          move-down = ["<Shift><Super>j"];

          switch-monitor-up = ["<Super>Up"];
          move-monitor-up = ["<Shift><Super>Up"];
          switch-monitor-down = ["<Super>Down"];
          move-monitor-down = ["<Shift><Super>Down"];
          switch-monitor-left = ["<Super>Left"];
          move-monitor-left = ["<Shift><Super>Left"];
          switch-monitor-right = ["<Super>Right"];
          move-monitor-right = ["<Shift><Super>Right"];

          switch-up = [];
          switch-down = [];
          switch-up-workspace = [];
          move-up-workspace = [];
          switch-down-workspace = [];
          move-down-workspace = [];
          live-alt-tab = [];
          live-alt-tab-backward = [];
        };

        "org/gnome/shell/extensions/unite" = {
          enable-titlebar-actions = true;
          extend-left-box = true;
          greyscale-tray-icons = true;
          hide-window-titlebars = "always";
          restrict-to-primary-screen = false;
          show-desktop-name = true;
          show-legacy-tray = true;
          show-window-buttons = "never";
          show-window-title = "maximized";
        };
      };

      xdg.configFile."paperwm/user.js".text = ''
        var Meta = imports.gi.Meta;
        var Clutter = imports.gi.Clutter;
        var St = imports.gi.St;
        var Main = imports.ui.main;
        var Shell = imports.gi.Shell;

        // Extension local imports
        var Extension, Me, Tiling, Utils, App, Keybindings, Examples;

        function init() {
            // Runs _only_ once on startup

            // Initialize extension imports here to make gnome-shell-reload work
            Extension = imports.misc.extensionUtils.getCurrentExtension();
            Me = Extension.imports.user;
            Tiling = Extension.imports.tiling;
            Utils = Extension.imports.utils;
            Keybindings = Extension.imports.keybindings;
            Examples = Extension.imports.examples;
            App = Extension.imports.app;
            Settings = Extension.imports.settings;

            App.customHandlers['emacs.desktop'] =
                () => imports.misc.util.spawn(['emacsclient', '--eval', '(make-frame)']);
        }

        function enable() {
            // Runs on extension reloads, eg. when unlocking the session
        }

        function disable() {
            // Runs on extension reloads eg. when locking the session (`<super>L).
        }
      '';
    })
  ]);
}
