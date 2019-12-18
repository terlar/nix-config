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

  # Enable secrets store.
  services.gnome3.gnome-keyring.enable = true;
  security.pam.services.lightdm.enableGnomeKeyring = true;
}
