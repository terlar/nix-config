{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    editorconfig-core-c
    exercism
    gdb
    global
    httpie
    jq
    plantuml
    python3Packages.pygments
    python3Packages.yamllint
    awscli
    pssh
    ttyrec
  ];
}
