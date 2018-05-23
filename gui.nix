{ config, pkgs, ... }:

{
  imports = [
    ./fonts.nix
    ./gui/i3.nix
    ./gui/lightdm.nix
    ./gui/ibus.nix
  ];

  # Graphical boot process
  boot.plymouth.enable = true;

  environment.systemPackages = with pkgs; [
    slop maim imagemagick
    chromium firefox qutebrowser
    alacritty kitty
    krita
    mpv
    spotify
    slack
  ];

  # Start a DBus session
  services.xserver.startDbusSession = true;

  # Permission escalation
  security.polkit.enable = true;

  # Auto-mount
  services.udisks2.enable = true;
}
