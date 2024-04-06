{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.yubikey;
in
{
  options.profiles.yubikey = {
    enable = lib.mkEnableOption "YubiKey";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.yubikey-personalization ];

    services = {
      udev = {
        enable = lib.mkDefault true;
        packages = [ pkgs.yubikey-personalization ];
      };
    };

    programs.yubikey-touch-detector.enable = lib.mkDefault true;
  };
}
