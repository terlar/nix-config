{ config, pkgs, ... }:

{
  imports = [ ./fonts.nix ];

  # Graphical boot process.
  boot.plymouth.enable = true;

  # Permission escalation.
  security.polkit.enable = true;

  # Enable secrets store.
  services.gnome3.gnome-keyring.enable = true;
  security.pam.services.lightdm.enableGnomeKeyring = true;

  environment.systemPackages = with pkgs; [
    # appearance
    gnome2.gtk
    gnome3.gtk

    # desktop
    gnome3.gcr
    gnome3.gnome-keyring
    gnome3.seahorse
    libgnome-keyring
    libnotify
    networkmanagerapplet
    pavucontrol
    xfce.xfce4-notifyd
  ];
}
