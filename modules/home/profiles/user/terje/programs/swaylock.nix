{ lib, config, ... }:

let
  cfg = config.profiles.user.terje.programs.swaylock;
in
{
  options.profiles.user.terje.programs.swaylock = {
    enable = lib.mkEnableOption "swaylock configuration for Terje";
  };

  config = lib.mkIf cfg.enable {
    programs.swaylock = {
      enable = true;
      settings = {
        image = "~/.config/swaylock/image.png";
        daemonize = true;
        ignore-empty-password = true;
        indicator-radius = 150;
        key-hl-color = "61768ff2";
        ring-color = "61768ff2";
        text-color = "ffffffe6";
        inside-clear-color = "0b0b0cf2";
        ring-clear-color = "61768ff2";
        text-clear-color = "ffffffe6";
        inside-ver-color = "0b0b0cf2";
        ring-ver-color = "61768ff2";
        text-ver-color = "ffffffe6";
        bs-hl-color = "3c3836ff";
        inside-wrong-color = "c30505ff";
        ring-wrong-color = "c30505ff";
        text-wrong-color = "ffffffff";
      };
    };
  };
}
