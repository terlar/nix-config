{ config, pkgs, ... }:

{
  environment = {
    sessionVariables = {
      GTK2_RC_FILES = "${pkgs.gnome-themes-extra}/share/themes/HighContrast/gtk-2.0/gtkrc";
      GTK_THEME = "HighContrast";
      QT_STYLE_OVERRIDE = "HighContrast";
      XCURSOR_THEME = "HighContrast";
      XCURSOR_SIZE = "64";
    };
  };

  services.xserver.displayManager.lightdm = {
    background = "#d5d2c8";
    greeters.gtk = {
      theme = {
        name = "HighContrast";
        package = pkgs.gnome3.gtk;
      };

      iconTheme = {
        name = "Paper";
        package = pkgs.paper-icon-theme;
      };
    };
  };
}
