{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    light
  ];

  programs.light.enable = true;
}
