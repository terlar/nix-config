{ pkgs, ... }:

{
  services.xserver.enable = true;

  # Display manager
  services.xserver.displayManager.gdm.enable = true;

  # Desktop manager
  services.xserver.desktopManager.gnome3.enable = true;
  services.dbus.packages = [ pkgs.gnome3.dconf ];
}
