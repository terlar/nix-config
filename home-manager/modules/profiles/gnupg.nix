{
  config,
  lib,
  ...
}: let
  cfg = config.profiles.gnupg;
in {
  options.profiles.gnupg = {
    enable = lib.mkEnableOption "GnuPG Profile";
  };

  config = lib.mkIf cfg.enable {
    programs.gpg = {
      enable = true;
      settings.keyserver = lib.mkDefault "hkps://keys.openpgp.org";
    };

    services.gpg-agent = {
      enable = true;
      enableSshSupport = lib.mkDefault true;
    };
  };
}
