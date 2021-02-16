{ config, lib, pkgs, ... }:

with lib;
let cfg = config.profiles.highContrast;
in
{
  options.profiles.highContrast = {
    enable = mkEnableOption "High contrast profile";
  };

  config = mkIf cfg.enable {
    gtk = {
      theme = {
        name = "HighContrast";
        package = pkgs.gnome-themes-extra;
      };

      # When HighContrast theme is enabled it will automatically use those icons, so this
      # is a fall-back in case icons doesn't exist in the HighContrast theme.
      iconTheme = {
        name = "Paper";
        package = pkgs.paper-icon-theme;
      };
    };
  };
}
