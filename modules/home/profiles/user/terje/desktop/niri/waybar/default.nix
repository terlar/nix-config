{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.profiles.user.terje.desktop.niri.waybar;
in
{
  options.profiles.user.terje.desktop.niri.waybar = {
    enable = lib.mkEnableOption "Niri Waybar profile for Terje";
  };

  config = lib.mkIf cfg.enable {
    services.network-manager-applet.enable = true;
    wayland.windowManager.niri.spawnAtStartup = [ "waybar" ];

    programs = {
      waybar = {
        enable = true;
        settings.mainBar = {
          margin-top = 4;
          margin-left = 4;
          margin-right = 4;
          spacing = 0;

          modules-left = [ "tray" ];
          modules-center = [ "clock" ];
          modules-right = [
            "cpu"
            "memory"
            "battery"
            "idle_inhibitor"
          ];

          idle_inhibitor = {
            format = "{icon}";
            format-icons = {
              activated = "";
              deactivated = "";
            };
          };

          battery = {
            states = {
              warning = 25;
              critical = 10;
            };
            format = "{icon} {capacity}%";
            format-charging = " {icon} {capacity}%";
            format-full = " {icon} {capacity}%";
            format-icons = [
              ""
              ""
              ""
              ""
              ""
            ];
            format-time = "{H}h{M}m";
            interval = 30;
            on-click = lib.getExe pkgs.gnome-power-manager;
          };

          cpu = {
            interval = 5;
            format = "▣ {usage}% ({load})";
            states = {
              warning = 70;
              critical = 90;
            };
          };

          memory = {
            interval = 30;
            format = " {used:0.1f}G/{total:0.1f}G";
          };

          clock = {
            interval = 1;
            format = "{:%e %B %H:%M}";
            tooltip-format = ''
              <big>{:%Y %B}</big>
              <tt><big>{calendar}</big></tt>
            '';
            on-click = lib.getExe pkgs.gnome-calendar;
          };

          tray = {
            icon-size = 20;
          };

          "wlr/taskbar" = {
            format = "{icon}";
            tooltip-format = "{title} | {app_id}";
            on-click = "activate";
            on-click-middle = "close";
            on-click-right = "fullscreen";
          };
        };

        style = builtins.readFile ./style.css;
      };
    };
  };
}
