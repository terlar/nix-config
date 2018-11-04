{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs.elmPackages; [
    elm
    elm-format
  ];
}
