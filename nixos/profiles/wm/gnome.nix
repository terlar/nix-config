{ pkgs, ... }:

{
  services.xserver.enable = true;

  # Display manager
  services.xserver.displayManager.gdm.enable = true;

  # Desktop manager
  services.xserver.desktopManager.gnome.enable = true;
  services.dbus.packages = [ pkgs.gnome3.dconf ];

  # Gnome 3 enables power-profiles-daemon which conflicts with TLP.
  services.tlp.enable = false;
}
