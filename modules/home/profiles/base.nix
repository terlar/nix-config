{ config, lib, ... }:

let
  inherit (lib) mkDefault;

  cfg = config.profiles.base;
in
{
  options.profiles.base = {
    enable = lib.mkEnableOption "base profile";
  };

  config = lib.mkIf cfg.enable {
    systemd.user.startServices = mkDefault "sd-switch";
    manual.html.enable = mkDefault true;

    xdg = {
      enable = mkDefault true;
      mimeApps.enable = mkDefault true;
    };

    profiles = {
      nix.enable = mkDefault true;
      shell.enable = mkDefault true;
    };
  };
}
