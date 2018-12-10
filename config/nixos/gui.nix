{ config, pkgs, ... }:

{
  imports = [
    ./gui/i3.nix
    ./gui/lightdm.nix
    ./gui/ibus.nix
  ];

  # Graphical boot process.
  boot.plymouth.enable = true;

  # Permission escalation.
  security.polkit.enable = true;

  # Start a DBus session.
  services.xserver.startDbusSession = true;

  environment.systemPackages = with pkgs; [
    firefox
    imagemagick
    kitty
    krita
    maim
    mpv
    qutebrowser
    slack
    slop
    spotify
  ];
}
