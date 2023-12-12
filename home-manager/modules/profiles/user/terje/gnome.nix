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
          {package = pkgs.gnomeExtensions.true-color-window-invert;}
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

        "org/gnome/shell/extensions/true-color-window-invert" = {
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
        ];
      };

      dconf.settings = {
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

          switch-up-workspace = ["<Super>bracketleft"];
          move-up-workspace = ["<Shift><Super>bracketleft"];
          switch-down-workspace = ["<Super>bracketright"];
          move-down-workspace = ["<Shift><Super>bracketright"];

          switch-first = ["<Super>Home"];
          switch-last = ["<Super>End"];

          switch-left = ["<Super>h"];
          move-left = ["<Shift><Super>h"];

          switch-right = ["<Super>l"];
          move-right = ["<Shift><Super>l"];

          switch-previous = ["<Shift><Super>Tab" "<Super>k"];
          move-up = ["<Shift><Super>k"];

          switch-next = ["<Super>Tab" "<Super>j"];
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
          previous-workspace = [];
          move-previous-workspace = [];
          previous-workspace-backward = [];
          move-previous-workspace-backward = [];
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
        // -*- mode: gnome-shell -*-
        const Extension = imports.misc.extensionUtils.getCurrentExtension();
        const App = Extension.imports.app;

        function enable() {
            let App = Extension.imports.app;
            App.customHandlers['emacs.desktop'] =
                () => imports.misc.util.spawn(['emacsclient', '--eval', '(make-frame)']);
        }

        function disable() {
            // Runs when extension is disabled
        }
      '';
    })
  ]);
}
