{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.profiles.user.terje.services.swayidle;
in
{
  options.profiles.user.terje.services.swayidle = {
    enable = lib.mkEnableOption "swayidle configuration for Terje";
  };

  config = lib.mkIf cfg.enable {
    services.swayidle = {
      enable = true;
      timeouts = [
        {
          timeout = 300;
          command = "${lib.getExe config.programs.swaylock.package} -fF";
        }
        {
          timeout = 420;
          command = "${lib.getExe config.wayland.windowManager.niri.package} msg action power-off-monitors";
        }
        {
          timeout = 1800;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];

      events = [
        {
          event = "before-sleep";
          command = "${lib.getExe config.programs.swaylock.package} -fF";
        }
      ];
    };
  };
}
