{
  config,
  lib,
  ...
}:

let
  inherit (lib) mkDefault mkIf;

  cfg = config.profiles.user.terje.ai;
in
{
  options.profiles.user.terje.ai = {
    enable = lib.mkEnableOption "AI profile for Terje";
  };

  config = mkIf cfg.enable {
    profiles = {
      user.terje = {
        programs = {
          mcp.enable = mkDefault true;
          opencode.enable = mkDefault true;
        };
      };
    };
  };
}
