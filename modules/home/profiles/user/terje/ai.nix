{ config, lib, ... }:
let
  cfg = config.profiles.user.terje.ai;
in
{
  options.profiles.user.terje.ai = {
    enable = lib.mkEnableOption "AI profile for terje";
  };

  config = lib.mkIf cfg.enable { services.ollama.enable = true; };
}
