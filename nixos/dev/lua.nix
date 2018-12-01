{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    luajit
    luajitPackages.luarocks
  ];
}
