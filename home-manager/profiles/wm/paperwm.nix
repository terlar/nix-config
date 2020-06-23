{ pkgs, ... }:

{
  dconf.settings = {
    "org/gnome/mutter" = { overlay-key = ""; };

    "org/gnome/desktop/wm/keybindings" = { activate-window-menu = [ "" ]; };

    "org/gnome/desktop/interface" = { gtk-key-theme = "Emacs"; };

    "org/gnome/shell" = {
      enabled-extensions = with pkgs.gnomeExtensions;
        [ ] ++ map (p: p.uuid) [ gtktitlebar paperwm switcher ];
    };

    "org/gnome/shell/overrides" = {
      attach-modal-dialogs = false;
      edge-tiling = false;
      workspaces-only-on-primary = false;
    };

    "org/gnome/shell/extensions/paperwm" = {
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

    "org/gnome/shell/extensions/switcher" = {
      activate-immediately = false;
      never-show-onboarding = true;
      show-switcher = [ "<Super>w" ];
    };
  };
}