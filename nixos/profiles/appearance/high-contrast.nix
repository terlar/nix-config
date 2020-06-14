{ pkgs, ... }:

{
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
