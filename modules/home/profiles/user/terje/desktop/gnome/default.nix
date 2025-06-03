{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    types
    ;

  cfg = config.profiles.user.terje.desktop.gnome;

  majorVersionFromPackage =
    pkg:
    lib.pipe pkg [
      lib.getVersion
      lib.versions.major
      lib.toInt
    ];

  gnomeExtensions = pkgs."gnome${builtins.toString cfg.version}Extensions";
  getExtensionPackage =
    fullName:
    let
      name = lib.pipe fullName [
        (lib.splitString "@")
        builtins.head
      ];
    in
    gnomeExtensions.${fullName} or pkgs.gnomeExtensions.${name};
in
{
  options.profiles.user.terje.desktop.gnome = {
    enable = mkEnableOption "GNOME profile for Terje";

    version = mkOption {
      type = types.number;
      default = majorVersionFromPackage pkgs.gnome-shell;
      example = 45;
      description = "GNOME version for compatibility.";
    };

    paperwm = {
      enable = mkEnableOption "Use PaperWM";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs.gnome-shell = {
        enable = true;
        extensions = [
          { package = getExtensionPackage "color-picker@tuberry"; }
          { package = getExtensionPackage "miniview@thesecretaryofwar.com"; }
          { package = pkgs.gnomeExtensions.wtmb-window-thumbnails; }
        ];
      };

      services.gpg-agent.pinentry.package = lib.mkDefault pkgs.pinentry-gnome3;

      dconf.settings = {
        "org/gnome/shell" = {
          disabled-extensions = [
            "ding@rastersoft.com"
            "ubuntu-dock@ubuntu.com"
          ];
        };

        "desktop/ibus/panel/emoji" = {
          hotkey = [ ];
          unicode-hotkey = [ ];
        };

        "org/gnome/desktop/wm/keybindings" = {
          activate-window-menu = [ ];
          hide-window = [ ];
          restore-window = [ ];
          switch-applications = [ ];
          switch-applications-backward = [ ];
        };

        "org/gnome/settings-daemon/plugins/media-keys" = {
          screensaver = [ "<Super><Alt>l" ];
        };

        "org/gnome/shell/extensions/miniview" = {
          showme = false;
        };

        "org/gnome/shell/extensions/true-color-window-invert" = {
          invert-window-shortcut = [ "<Super>exclam" ];
        };
      };
    }

    (mkIf cfg.paperwm.enable {
      programs.gnome-shell = {
        extensions = [
          { package = getExtensionPackage "paperwm@paperwm.github.com"; }
          { package = getExtensionPackage "user-theme@gnome-shell-extensions.gcampax.github.com"; }
        ];
      };

      dconf.settings = {
        "org/gnome/mutter" = {
          attach-modal-dialogs = false;
          edge-tiling = false;
          workspaces-only-on-primary = false;
        };

        "org/gnome/shell/extensions/user-theme" = {
          name = "Default";
        };

        "org/gnome/shell/extensions/paperwm" = {
          animation-time = 0.1;
          minimap-scale = 0.0;
          show-window-position-bar = false;
          show-workspace-indicator = false;
          use-default-background = true;

          selection-border-size = 4;
          selection-border-radius-top = 0;
          window-gap = 4;

          horizontal-margin = 0;
          vertical-margin = 4;
          vertical-margin-bottom = 4;
        };

        "org/gnome/shell/extensions/paperwm/keybindings" = {
          new-window = [ "<Super>Return" ];
          close-window = [ "<Super>q" ];

          toggle-scratch = [ "<Super><Shift>v" ];
          toggle-scratch-layer = [ "<Super>v" ];

          slurp-in = [ "<Super>Comma" ];
          barf-out = [ "<Super>Period" ];

          switch-up-workspace = [ "<Super>i" ];
          move-up-workspace = [ "<Shift><Ctrl>i" ];
          switch-down-workspace = [ "<Super>u" ];
          move-down-workspace = [ "<Super><Ctrl>u" ];

          switch-first = [ "<Super>Home" ];
          switch-last = [ "<Super>End" ];

          switch-left = [ "<Super>h" ];
          move-left = [ "<Super><Ctrl>h" ];

          switch-right = [ "<Super>l" ];
          move-right = [ "<Super><Ctrl>l" ];

          switch-previous = [
            "<Shift><Super>Tab"
            "<Super>k"
          ];
          move-up = [ "<Super><Ctrl>k" ];

          switch-next = [
            "<Super>Tab"
            "<Super>j"
          ];
          move-down = [ "<Super><Ctrl>j" ];

          switch-monitor-above = [ "<Super><Shift>k" ];
          move-monitor-above = [ "<Super><Shift><Ctrl>k" ];
          switch-monitor-below = [ "<Super><Shift>j" ];
          move-monitor-below = [ "<Super><Shift><Ctrl>j" ];
          switch-monitor-left = [ "<Super><Shift>h" ];
          move-monitor-left = [ "<Super><Shift><Ctrl>h" ];
          switch-monitor-right = [ "<Super><Shift>l" ];
          move-monitor-right = [ "<Super><Shift><Ctrl>l" ];

          resize-h-dec = [ "<Super><Shift>Minus" ];
          resize-h-inc = [ "<Super><Shift>Equal" ];
          resize-w-dec = [ "<Super>Minus" ];
          resize-w-inc = [ "<Super>Equal" ];

          switch-up = [ ];
          switch-down = [ ];
          previous-workspace = [ ];
          move-previous-workspace = [ ];
          previous-workspace-backward = [ ];
          move-previous-workspace-backward = [ ];
          live-alt-tab = [ ];
          live-alt-tab-backward = [ ];
        };
      };

      xdg = {
        dataFile."themes/Default/gnome-shell/gnome-shell.css".text = ''
          #panel {
            font-size: 12px;
            height: 24px;
          }
        '';

        configFile."paperwm/user.js".text = ''
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
      };
    })
  ]);
}
