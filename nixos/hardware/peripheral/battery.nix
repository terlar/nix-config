{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    powertop
  ];

  services.acpid.enable = true;
  services.tlp.enable = true;

  powerManagement.enable = true; 
}
