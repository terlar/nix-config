{ config, pkgs, ... }:

{
  boot.extraModulePackages = [ config.boot.kernelPackages.sysdig ];
  environment.systemPackages = [ pkgs.sysdig ];
}
