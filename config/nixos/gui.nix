{ config, pkgs, ... }:

{
  imports = [
    ./gui/theme.nix
    ./gui/ibus.nix
  ];

  # Graphical boot process.
  boot.plymouth.enable = true;

  # Permission escalation.
  security.polkit.enable = true;

  services.autorandr.enable = true;

  # Enable secrets store.
  services.gnome3.gnome-keyring.enable = true;
  security.pam.services.lightdm.enableGnomeKeyring = true;

  services.xserver = {
    enable = true;
    autorun = true;

    # Start a DBus session.
    startDbusSession = true;

    displayManager.lightdm = {
      enable = true;
      greeters.gtk.enable = true;
    };
  };

  services.gnome3.at-spi2-core.enable = true;
}
