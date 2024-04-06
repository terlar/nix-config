{ config, lib, ... }:
let
  inherit (lib) types;
  cfg = config.profiles.user.terje.browser;
in
{
  options.profiles.user.terje.browser = {
    enable = lib.mkEnableOption "Browser profile for terje";

    program = lib.mkOption {
      type = types.enum [
        "brave"
        "firefox"
        "qutebrowser"
      ];
      default = "brave";
      description = "Browser program to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    custom.defaultBrowser = {
      enable = true;
      package = lib.mkDefault config.programs.${cfg.program}.package;
    };

    profiles.user.terje.programs = {
      brave = lib.mkIf (cfg.program == "brave") { enable = true; };

      firefox = lib.mkIf (cfg.program == "firefox") { enable = true; };

      qutebrowser = lib.mkIf (cfg.program == "qutebrowser") { enable = true; };
    };
  };
}
