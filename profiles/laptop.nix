{ pkgs, ... }:

{
  imports = [
    ../config/nixos/backlight.nix
    ../config/nixos/battery.nix

    ../config/nixos/common.nix
  ];

  networking.networkmanager.enable = true;

  hardware = {
    bluetooth.enable = true;
    pulseaudio = {
      enable = true;
      extraModules = [ pkgs.pulseaudio-modules-bt ];
      package = pkgs.pulseaudioFull;
      extraConfig = ''
        load-module module-switch-on-connect
      '';
    };
  };

  services = {
    # Enable zero-configuration networking and service discorvery.
    avahi = {
      enable = true;
      nssmdns = true;
    };

    # Monitor and control temperature.
    thermald.enable = true;
  };
}
