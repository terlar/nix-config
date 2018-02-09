{ config, pkgs, ... }:

{
  networking.wireless = {
    enable = true;
    userControlled.enable = true;
  };
}
