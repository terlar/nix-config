{ config, pkgs, ... }:

{
  imports = [
    ../config/nixos/docker.nix
  ];

  boot.extraModulePackages = [
    config.boot.kernelPackages.sysdig
  ];

  environment.systemPackages = with pkgs; [
    bat
    curlie
    direnv
    docker
    docker-slim
    docker_compose
    editorconfig-core-c
    gnumake
    hey
    jq
    nodePackages.jsonlint
    nodePackages.prettier
    plantuml
    saw
    shellcheck
    sysdig
    termtosvg
  ];
}
