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
      package = pkgs.pass.withExtensions (ext: [
        ext.pass-import
        ext.pass-genphrase
        ext.pass-update
        ext.pass-otp
      ]);
    };
  };
}
