{ pkgs, ... }:

{
  gtk = {
    enable = true;

    theme = {
      name = "HighContrast";
      package = pkgs.gnome-themes-extra;
    };

    iconTheme = {
      name = "Paper";
      package = pkgs.paper-icon-theme;
    };
  };
}
