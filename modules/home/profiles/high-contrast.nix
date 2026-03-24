{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.profiles.highContrast;
  theme = {
    name = "HighContrast";
    package = pkgs.gnome-themes-extra;
  };
in
{
  options.profiles.highContrast = {
    enable = lib.mkEnableOption "high contrast profile";
  };

  config = lib.mkIf cfg.enable {
    gtk = {
      inherit theme;
      gtk4 = { inherit theme; };

      # When HighContrast theme is enabled it will automatically use those icons, so this
      # is a fall-back in case icons doesn't exist in the HighContrast theme.
      iconTheme = {
        name = "Paper";
        package = pkgs.paper-icon-theme;
      };
    };

    dconf.settings = {
      "org/gnome/desktop/a11y/interface" = {
        high-contrast = true;
      };
    };
  };
}
