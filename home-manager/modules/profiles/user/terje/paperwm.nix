{ config, lib, pkgs, ... }:

with lib;
let cfg = config.profiles.user.terje.paperwm;
in
{
  options.profiles.user.terje.paperwm = {
    enable = mkEnableOption "PaperWM profile for terje";
  };

  config = mkIf cfg.enable {
    profiles.user.terje.gnome = true;

    programs.gnome-shell = {
      extensions = with pkgs.gnomeExtensions; [
        { package = paperwm; }
        { package = unite; }
        { package = cleaner-overview; }
        { package = vertical-overview; }
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
        horizontal-margin = 8;
        use-default-background = false;
        vertical-margin = 0;
        vertical-margin-bottom = 8;
        window-gap = 8;
      };

      "org/gnome/shell/extensions/paperwm/keybindings" = {
        new-window = [ "<Super>Return" ];
        close-window = [ "<Super>BackSpace" ];

        toggle-scratch = [ "<Shift><Super>s" ];
        toggle-scratch-layer = [ "<Super>s" ];

        slurp-in = [ "<Super>i" ];
        barf-out = [ "<Super>o" ];

        previous-workspace = [ "<Super>Tab" ];
        move-previous-workspace = [ "<Control><Super>Tab" ];
        previous-workspace-backward = [ "<Shift><Super>Tab" ];
        move-previous-workspace-backward = [ "<Control><Shift><Super>Tab" ];

        switch-first = [ "<Super>Home" ];
        switch-last = [ "<Super>End" ];

        switch-left = [ "<Super>Left" "<Super>h" ];
        move-left = [ "<Shift><Super>Left" "<Shift><Super>comma" "<Shift><Super>h" ];

        switch-right = [ "<Super>Right" "<Super>l" ];
        move-right = [ "<Shift><Super>Right" "<Shift><Super>period" "<Shift><Super>l" ];

        switch-previous = [ "<Super>Up" "<Super>comma" "<Super>k" ];
        move-up = [ "<Shift><Super>Up" "<Shift><Super>k" ];

        switch-next = [ "<Super>Down" "<Super>period" "<Super>j" ];
        move-down = [ "<Shift><Super>Down" "<Shift><Super>j" ];

        switch-monitor-left = [ ];
        move-monitor-left = [ ];
        switch-monitor-right = [ ];
        move-monitor-right = [ ];

        switch-up = [ ];
        switch-down = [ ];
        switch-up-workspace = [ ];
        move-up-workspace = [ ];
        switch-down-workspace = [ ];
        move-down-workspace = [ ];
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
  };
}
