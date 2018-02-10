{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    crystal
  ];
}
