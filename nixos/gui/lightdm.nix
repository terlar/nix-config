{ config, pkgs, ... }:

{
  imports = [
    ./theme.nix
    ./xserver.nix
  ];

  services.xserver.displayManager.lightdm = {
    enable = true;
    greeters.gtk.enable = true;
  };
}
