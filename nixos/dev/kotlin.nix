{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    kotlin
  ];
}
