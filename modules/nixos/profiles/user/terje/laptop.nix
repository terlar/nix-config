{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.profiles.user.terje.laptop;
in {
  options.profiles.user.terje.laptop = {
    enable = lib.mkEnableOption "Laptop profile for terje";
  };

  config = lib.mkIf cfg.enable {
    networking.networkmanager.enable = true;

    hardware.bluetooth.enable = true;

    services = {
      # Enable zero-configuration networking and service discorvery.
      avahi = {
        enable = lib.mkDefault true;
        nssmdns4 = lib.mkDefault true;
      };
    };

    environment.systemPackages = [pkgs.powertop];
  };
}
