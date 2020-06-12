{ config, pkgs, ... }:

{
  services.acpid.enable = true;
  services.tlp.enable = true;

  powerManagement.enable = true;

  environment.systemPackages = with pkgs; [ powertop ];
}
