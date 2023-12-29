{
  config,
  lib,
  ...
}: let
  cfg = config.profiles.user.terje.programs.brave;
in {
  options.profiles.user.terje.programs.brave = {
    enable = lib.mkEnableOption "Brave config for terje";
  };

  config = lib.mkIf cfg.enable {
    programs.brave = {
      enable = true;
    };
  };
}
