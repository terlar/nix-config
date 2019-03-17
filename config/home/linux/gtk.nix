{ pkgs, ... }:

{
  gtk = {
    theme = {
      name = "HighContrast";
      package = pkgs.gnome3.gtk;
    };

    iconTheme = {
      name = "Paper";
      package = pkgs.paper-icon-theme;
    };
  };
}
