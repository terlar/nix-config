{ config, lib, pkgs, ... }:

with lib;
let cfg = config.profiles.user.terje.gnome;
in
{
  options.profiles.user.terje.gnome = {
    enable = mkEnableOption "GNOME profile for terje";
  };

  config = mkIf cfg.enable {
    profiles.gnome.enable = true;

    programs.gnome-shell = {
      enable = true;
      extensions = with pkgs.gnomeExtensions; [
        { package = true-color-invert; }
        { package = miniview; }
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

      "org/gnome/desktop/wm/keybindings" = {
        activate-window-menu = [ ];
        switch-applications = [ ];
        switch-applications-backward = [ ];
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        screensaver = [ "<Super>q" ];
      };

      "org/gnome/shell/extensions/miniview" = {
        showme = false;
      };
    };
  };
}
