{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bashdb
    bats
    shellcheck
  ];
}
