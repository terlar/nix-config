{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) types;

  cfg = config.profiles.user.terje.gnome;

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
  options.profiles.user.terje.gnome = {
    enable = lib.mkEnableOption "GNOME profile for terje";

    version = lib.mkOption {
      type = types.number;
      default = majorVersionFromPackage pkgs.gnome.gnome-shell;
      example = 45;
      description = "GNOME version for compatibility.";
    };

    materialShell = {
      enable = lib.mkEnableOption "Use Material Shell";
    };
    paperwm = {
      enable = lib.mkEnableOption "Use PaperWM";
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        programs.gnome-shell = {
          enable = true;
          extensions = [
            { package = getExtensionPackage "true-color-window-invert@lynet101"; }
            { package = getExtensionPackage "miniview@thesecretaryofwar.com"; }
          ];
        };

        services.gpg-agent.pinentryPackage = pkgs.pinentry-gnome3;

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
            screensaver = [ "<Super>q" ];
          };

          "org/gnome/shell/extensions/miniview" = {
            showme = false;
          };

          "org/gnome/shell/extensions/true-color-window-invert" = {
            invert-window-shortcut = [ "<Super>exclam" ];
          };
        };
      }

      (lib.mkIf cfg.materialShell.enable {
        programs.gnome-shell = {
          extensions = [ { package = gnomeExtensions."material-shell@papyelgringo"; } ];
        };
      })

      (lib.mkIf cfg.paperwm.enable {
        programs.gnome-shell = {
          extensions = [
            { package = getExtensionPackage "paperwm@paperwm.github.com"; }
            { package = getExtensionPackage "unite@hardpixel.eu"; }
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
            new-window = [ "<Super>Return" ];
            close-window = [ "<Super>BackSpace" ];

            toggle-scratch = [ "<Shift><Super>s" ];
            toggle-scratch-layer = [ "<Super>s" ];

            slurp-in = [ "<Super>i" ];
            barf-out = [ "<Super>o" ];

            switch-up-workspace = [ "<Super>bracketleft" ];
            move-up-workspace = [ "<Shift><Super>bracketleft" ];
            switch-down-workspace = [ "<Super>bracketright" ];
            move-down-workspace = [ "<Shift><Super>bracketright" ];

            switch-first = [ "<Super>Home" ];
            switch-last = [ "<Super>End" ];

            switch-left = [ "<Super>h" ];
            move-left = [ "<Shift><Super>h" ];

            switch-right = [ "<Super>l" ];
            move-right = [ "<Shift><Super>l" ];

            switch-previous = [
              "<Shift><Super>Tab"
              "<Super>k"
            ];
            move-up = [ "<Shift><Super>k" ];

            switch-next = [
              "<Super>Tab"
              "<Super>j"
            ];
            move-down = [ "<Shift><Super>j" ];

            switch-monitor-above = [ "<Super>Up" ];
            move-monitor-above = [ "<Shift><Super>Up" ];
            switch-monitor-below = [ "<Super>Down" ];
            move-monitor-below = [ "<Shift><Super>Down" ];
            switch-monitor-left = [
              "<Super>Left"
              "<Alt><Super>bracketleft"
            ];
            move-monitor-left = [
              "<Shift><Super>Left"
              "<Shift><Alt><Super>bracketleft"
            ];
            switch-monitor-right = [
              "<Super>Right"
              "<Alt><Super>bracketright"
            ];
            move-monitor-right = [
              "<Shift><Super>Right"
              "<Shift><Alt><Super>bracketright"
            ];

            switch-up = [ ];
            switch-down = [ ];
            previous-workspace = [ ];
            move-previous-workspace = [ ];
            previous-workspace-backward = [ ];
            move-previous-workspace-backward = [ ];
            live-alt-tab = [ ];
            live-alt-tab-backward = [ ];
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
    ]
  );
}
