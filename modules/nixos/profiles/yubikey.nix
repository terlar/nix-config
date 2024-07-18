{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkDefault mkEnableOption mkIf;

  cfg = config.profiles.yubikey;
in
{
  options.profiles.yubikey = {
    enable = mkEnableOption "YubiKey";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.yubikey-personalization ];

    services = {
      udev = {
        enable = mkDefault true;
        packages = [ pkgs.yubikey-personalization ];
      };
    };

    programs.yubikey-touch-detector.enable = mkDefault true;
  };
}
