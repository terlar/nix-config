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
  ];

  # Permission escalation
  security.polkit.enable = true;

  # Auto-mount
  services.udisks2.enable = true;
}
