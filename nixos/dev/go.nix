{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    go
    gocode
    godef
  ];
}
