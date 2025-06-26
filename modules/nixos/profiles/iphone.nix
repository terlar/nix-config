{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkDefault mkEnableOption mkIf;

  cfg = config.profiles.iphone;
in
{
  options.profiles.iphone = {
    enable = mkEnableOption "iPhone";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      # pkgs.idevicerestore
      pkgs.libimobiledevice
      pkgs.ifuse
    ];

    services.usbmuxd = {
      enable = mkDefault true;
      package = pkgs.usbmuxd2;
    };
  };
}
