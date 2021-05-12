{ config, pkgs, ... }:

{
  services.acpid.enable = true;

  powerManagement.enable = true;

}
,
