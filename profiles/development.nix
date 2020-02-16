{ config, ... }:

{
  imports = [
    ../config/nixos/docker.nix
  ];

  boot.extraModulePackages = [
    config.boot.kernelPackages.sysdig
  ];
}
