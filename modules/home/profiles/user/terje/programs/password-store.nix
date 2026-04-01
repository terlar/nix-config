{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.profiles.user.terje.programs.password-store;
in
{
  options.profiles.user.terje.programs.password-store = {
    enable = lib.mkEnableOption "password-store configuration for Terje";
  };

  config = lib.mkIf cfg.enable {
    programs.password-store = {
      enable = true;
      settings.PASSWORD_STORE_DIR = "$XDG_DATA_HOME/password-store";
      package = pkgs.pass.withExtensions (ext: [
        ext.pass-import
        ext.pass-genphrase
        ext.pass-update
        ext.pass-otp
      ]);
    };

    services.pass-secret-service.enable = true;
  };
}
