{ config, pkgs, ... }:

{
  services.printing = {
    enable = true;
    drivers = [
      pkgs.gutenprint
    ];
  };

  services.avahi.enable = true;
  services.avahi.nssmdns = true;
}
