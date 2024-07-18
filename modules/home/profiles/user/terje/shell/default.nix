{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkDefault mkIf;

  cfg = config.profiles.user.terje.shell;
in
{
  options.profiles.user.terje.shell = {
    enable = lib.mkEnableOption "Shell profile for Terje";
  };

  config = mkIf cfg.enable {
    profiles = {
      user.terje = {
        shell.fish = {
          enable = mkDefault true;
          enableBaseConfig = mkDefault true;
        };

        programs = {
          glow.enable = mkDefault true;
          password-store.enable = mkDefault true;
        };
      };
    };

    home.packages = [
      pkgs.pdfgrep
      pkgs.unzip
      pkgs.xsv
    ];
  };
}
