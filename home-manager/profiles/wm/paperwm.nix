{ pkgs, ... }:

{
  imports = [ ../programs/rofi.nix ];

  dconf.settings = {
    "org/gnome/desktop/wm/keybindings" = { activate-window-menu = [ "" ]; };

    "org/gnome/settings-daemon/plugins/media-keys".custom-keybindings = [
      "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/rofi/"
    ];

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/rofi" = {
      binding = "<Super>w";
      command =
        "${pkgs.rofi}/bin/rofi -combi-modi drun,window,run -show combi -modi combi";
      name = "Rofi";
    };

    "org/gnome/desktop/interface" = { gtk-key-theme = "Emacs"; };

    "org/gnome/shell" = {
      enabled-extensions = with pkgs.gnomeExtensions;
        [ ] ++ map (p: p.uuid) [ gtktitlebar invert-window paperwm ];
    };

    "org/gnome/mutter" = {
      attach-modal-dialogs = false;
      edge-tiling = false;
      workspaces-only-on-primary = false;
      overlay-key = "";
    };

    "org/gnome/shell/extensions/paperwm" = {
      animation-time = 0.1;
      horizontal-margin = 8;
      use-default-background = false;
      vertical-margin = 0;
      vertical-margin-bottom = 8;
      window-gap = 8;
    };

    "org/gnome/shell/extensions/gtktitlebar" = {
      hide-window-titlebars = "always";
      restrict-to-primary-screen = false;
    };

    "org/gnome/shell/extensions/invert-window" = {
      "invert-window-shortcut" = [ "<Super>exclam" ];
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

        Settings.defwinprop({
            wm_class: "Rofi",
            focus: true,
        });
    }

    function enable() {
        // Runs on extension reloads, eg. when unlocking the session
    }

    function disable() {
        // Runs on extension reloads eg. when locking the session (`<super>L).
    }
  '';
}
