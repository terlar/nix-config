{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.profiles.user.terje.desktop.niri;
in
{
  options.profiles.user.terje.desktop.niri = {
    enable = lib.mkEnableOption "Niri profile for Terje";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.gnome-calendar
      pkgs.gnome-power-manager
      pkgs.overskride
      pkgs.swww
      pkgs.system-config-printer
    ];

    programs = {
      fuzzel.enable = true;
      swaylock.enable = true;
      waybar = {
        enable = true;
        settings.mainBar = {
          margin-top = 4;
          margin-left = 4;
          margin-right = 4;
          spacing = 0;

          modules-left = [
            "tray"
            "wlr/taskbar"
          ];
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
            on-click = "gnome-power-statistics";
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
            on-click = "gnome-calendar";
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

        style = ''
          * {
            font-size: 12px;
          }

          window#waybar {
            background: transparent;
            color: #ffffff;
          }

          #window,
          #workspaces {
            margin: 0 4px;
          }

          #workspaces button {
            padding: 0 0.4em;
            border-radius: 0;
            background-color: transparent;
            color: #ffffff;
            box-shadow: inset 0 -3px transparent;
          }

          #workspaces button:hover {
            background: rgba(0, 0, 0, 0.2);
            border-bottom: 2.5px solid;
            box-shadow: inset 0 -3px #ffffff;
          }

          #workspaces button.focused {
            background-color: #64727d;
            box-shadow: inset 0 -3px #ffffff;
          }

          #workspaces button.urgent {
            background-color: #eb4d4b;
          }

          window#waybar.hidden {
            opacity: 0.2;
          }

          button {
            box-shadow: none;
            border: none;
            border-radius: 0;
            transition-property: none;
          }

          button:hover {
            background: none;
            box-shadow: none;
            text-shadow: none;
            border: none;
            -gtk-icon-effect: none;
            -gtk-icon-shadow: none;
          }

          #clock,
          #battery,
          #cpu,
          #memory,
          #disk,
          #temperature,
          #backlight,
          #network,
          #pulseaudio,
          #wireplumber,
          #custom-media,
          #tray,
          #mode,
          #idle_inhibitor,
          #scratchpad,
          #mpd {
            padding: 0 10px;
            color: #f0f0ff;
            background-color: rgba(30, 30, 46, 0.6);
            border-radius: 99px;
          }

          label:focus {
            background-color: #000000;
          }

          #taskbar {
            margin-left: 4px;
          }

          #taskbar button {
            color: #f0f0ff;
            background-color: rgba(30, 30, 46, 0.6);
          }

          #taskbar button:first-child {
            border-radius: 99px 0 0 99px;
          }

          #taskbar button:last-child {
            border-radius: 0 99px 99px 0;
          }

          #taskbar button:first-child:last-child {
            border-radius: 99px;
          }

          #taskbar button:hover {
            background-color: rgba(49, 50, 68, 0.6);
          }

          #taskbar button.active {
            background-color: rgba(88, 91, 112, 0.6);
          }

          #taskbar button.active:hover {
            background-color: rgba(108, 112, 134, 0.6);
          }

          #tray > .passive {
            -gtk-icon-effect: dim;
          }

          #tray > .needs-attention {
            -gtk-icon-effect: highlight;
            background-color: #eb4d4b;
          }
        '';
      };
    };

    services = {
      network-manager-applet.enable = true;
      swayosd.enable = true;
    };

    wayland.windowManager.niri = {
      enable = true;
      xwayland.enable = lib.mkDefault false;

      settings = {
        input = {
          keyboard = {
            xkb.options = "ctrl:nocaps";
            repeat-delay = 500;
            repeat-rate = 33;
          };
          touchpad = {
            tap = [ ];
            natural-scroll = [ ];
          };
        };

        layout = {
          gaps = 5;
          focus-ring.width = 2;
        };

        binds = {
          "Mod+Return".spawn = "foot";
          "Mod+Shift+Return".spawn = "fuzzel";
          "Super+Alt+L".spawn = "swaylock";
          "Ctrl+Alt+Delete".quit = [ ];
          "Mod+Shift+P".power-off-monitors = [ ];

          "Mod+Shift+Slash".show-hotkey-overlay = [ ];

          "Print".screenshot = [ ];
          "Ctrl+Print".screenshot-screen = [ ];
          "Alt+Print".screenshot-window = [ ];

          "Mod+Q".close-window = [ ];

          "Mod+H".focus-column-left = [ ];
          "Mod+J".focus-window-down = [ ];
          "Mod+K".focus-window-up = [ ];
          "Mod+L".focus-column-right = [ ];
          "Mod+Ctrl+H".move-column-left = [ ];
          "Mod+Ctrl+J".move-window-down = [ ];
          "Mod+Ctrl+K".move-window-up = [ ];
          "Mod+Ctrl+L".move-column-right = [ ];

          "Mod+Home".focus-column-first = [ ];
          "Mod+End".focus-column-last = [ ];
          "Mod+Ctrl+Home".move-column-to-first = [ ];
          "Mod+Ctrl+End".move-column-to-last = [ ];

          "Mod+Shift+H".focus-monitor-left = [ ];
          "Mod+Shift+J".focus-monitor-down = [ ];
          "Mod+Shift+K".focus-monitor-up = [ ];
          "Mod+Shift+L".focus-monitor-right = [ ];
          "Mod+Shift+Ctrl+H".move-column-to-monitor-left = [ ];
          "Mod+Shift+Ctrl+J".move-column-to-monitor-down = [ ];
          "Mod+Shift+Ctrl+K".move-column-to-monitor-up = [ ];
          "Mod+Shift+Ctrl+L".move-column-to-monitor-right = [ ];

          "Mod+U".focus-workspace-down = [ ];
          "Mod+I".focus-workspace-up = [ ];
          "Mod+Ctrl+U".move-column-to-workspace-down = [ ];
          "Mod+Ctrl+I".move-column-to-workspace-up = [ ];
          "Mod+Shift+U".move-workspace-down = [ ];
          "Mod+Shift+I".move-workspace-up = [ ];

          "Mod+1".focus-workspace = [ 1 ];
          "Mod+2".focus-workspace = [ 2 ];
          "Mod+3".focus-workspace = [ 3 ];
          "Mod+4".focus-workspace = [ 4 ];
          "Mod+5".focus-workspace = [ 5 ];
          "Mod+6".focus-workspace = [ 6 ];
          "Mod+7".focus-workspace = [ 7 ];
          "Mod+8".focus-workspace = [ 8 ];
          "Mod+9".focus-workspace = [ 9 ];
          "Mod+Ctrl+1".move-column-to-workspace = [ 1 ];
          "Mod+Ctrl+2".move-column-to-workspace = [ 2 ];
          "Mod+Ctrl+3".move-column-to-workspace = [ 3 ];
          "Mod+Ctrl+4".move-column-to-workspace = [ 4 ];
          "Mod+Ctrl+5".move-column-to-workspace = [ 5 ];
          "Mod+Ctrl+6".move-column-to-workspace = [ 6 ];
          "Mod+Ctrl+7".move-column-to-workspace = [ 7 ];
          "Mod+Ctrl+8".move-column-to-workspace = [ 8 ];
          "Mod+Ctrl+9".move-column-to-workspace = [ 9 ];

          "Mod+BracketLeft".consume-or-expel-window-left = [ ];
          "Mod+BracketRight".consume-or-expel-window-right = [ ];
          "Mod+Comma".consume-window-into-column = [ ];
          "Mod+Period".expel-window-from-column = [ ];

          "Mod+R".switch-preset-column-width = [ ];
          "Mod+Shift+R".switch-preset-window-height = [ ];
          "Mod+Ctrl+R".reset-window-height = [ ];
          "Mod+F".maximize-column = [ ];
          "Mod+Shift+F".fullscreen-window = [ ];
          "Mod+Ctrl+F".expand-column-to-available-width = [ ];
          "Mod+C".center-column = [ ];

          "Mod+Minus".set-column-width = [ "-10%" ];
          "Mod+Equal".set-column-width = [ "+10%" ];
          "Mod+Shift+Minus".set-window-height = [ "-10%" ];
          "Mod+Shift+Equal".set-window-height = [ "+10%" ];

          "Mod+V".toggle-window-floating = [ ];
          "Mod+Shift+V".switch-focus-between-floating-and-tiling = [ ];
          "Mod+W".toggle-column-tabbed-display = [ ];

          XF86MonBrightnessUp = {
            _props.allow-when-locked = true;
            spawn = [
              "swayosd-client"
              "--brightness"
              "raise"
            ];
          };
          XF86MonBrightnessDown = {
            _props.allow-when-locked = true;
            spawn = [
              "swayosd-client"
              "--brightness"
              "lower"
            ];
          };

          XF86AudioRaiseVolume = {
            _props.allow-when-locked = true;
            spawn = [
              "swayosd-client"
              "--output-volume"
              "raise"
            ];
          };
          XF86AudioLowerVolume = {
            _props.allow-when-locked = true;
            spawn = [
              "swayosd-client"
              "--output-volume"
              "lower"
            ];
          };
          XF86AudioMute = {
            _props.allow-when-locked = true;
            spawn = [
              "swayosd-client"
              "--output-volume"
              "mute-toggle"
            ];
          };
          XF86AudioMicMute = {
            _props.allow-when-locked = true;
            spawn = [
              "swayosd-client"
              "--input-volume"
              "mute-toggle"
            ];
          };

          XF86AudioPlay = {
            _props.allow-when-locked = true;
            spawn = [
              "swayosd-client"
              "--playerctl"
              "play-pause"
            ];
          };
          XF86AudioNext = {
            _props.allow-when-locked = true;
            spawn = [
              "swayosd-client"
              "--playerctl"
              "next"
            ];
          };
          XF86AudioPrev = {
            _props.allow-when-locked = true;
            spawn = [
              "swayosd-client"
              "--playerctl"
              "prev"
            ];
          };
        };
      };

      extraConfig = ''
        spawn-at-startup "swww-daemon"
        spawn-at-startup "waybar"
      '';
    };
  };
}
