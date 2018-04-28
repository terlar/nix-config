{ config, pkgs, ... }:

{
  imports = [
    ./xserver.nix
  ];

  environment = {
    systemPackages = with pkgs; [
      paper-gtk-theme
      paper-icon-theme
      gnome2.gtk
      gnome3.gtk
    ];
    
    sessionVariables = {
      GTK2_RC_FILES = "${pkgs.gnome2.gtk}/share/themes/HighContrast/gtk-2.0/gtkrc";
      GTK_THEME = "HighContrast";
      QT_STYLE_OVERRIDE = "HighContrast";
      XCURSOR_THEME = "HighContrast";
      XCURSOR_SIZE = "64";
    };
  };

  services.xserver.displayManager.lightdm = {
    background = "#1e1e1e";
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
