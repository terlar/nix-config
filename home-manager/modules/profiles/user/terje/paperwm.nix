{ config, lib, pkgs, ... }:

with lib;
let cfg = config.profiles.user.terje.paperwm;
in
{
  options.profiles.user.terje.paperwm = {
    enable = mkEnableOption "PaperWM profile for terje";
  };

  config = mkIf cfg.enable {
    profiles.gnome.enable = true;

    programs.gnome-shell = {
      enable = true;
      extensions = with pkgs.gnomeExtensions; [
        { package = gtktitlebar; }
        { package = invert-window; }
        { package = paperwm; }
      ];
    };

    dconf.settings = with lib.hm.gvariant; {
      "org/gnome/desktop/input-sources" = {
        sources = map mkTuple [
          [ "xkb" "us+altgr-intl" ]
          [ "xkb" "se" ]
          [ "ibus" "libpinyin" ]
        ];
      };

      "org/gnome/desktop/wm/keybindings" = { activate-window-menu = [ "" ]; };

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
