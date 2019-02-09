{ config, pkgs, lib, ... }:

{
  home = {
    packages = with pkgs; [
      i3lock-color
      i3status
    ];
  };

  services = {
    screen-locker = {
      enable = true;
      lockCmd = "${pkgs.i3lock-color}/bin/i3lock-color --clock --color=333333";
      inactiveInterval = 10;
    };

    pasystray.enable = true;
  };

  xsession = {
    enable = true;

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;

      config = let
        modifier = "Mod4";
        fonts = [ "sans-serif 9" ];
        tile = "exec ${pkgs.scripts.window_tiler}/bin/window_tiler";
      in {
        # Autostart
        startup = [
          {
            command = "${pkgs.dex}/bin/dex -ae i3";
            always = true;
            notification = false;
          }
          {
            command = "${pkgs.slack}/bin/slack";
            always = true;
            notification = false;
          }
        ];

        # UI
        inherit fonts;

        # Borders
        window.border = 0;
        floating.border = 3;

        # Gaps
        gaps = {
          inner = 5;
          outer = 0;
        };

        # Status bar
        bars = [
          {
            inherit fonts;
            statusCommand = "${pkgs.i3status}/bin/i3status";
            colors = {
              background = "#333333";
            };
          }
        ];

        focus = {
          followMouse = false;
        };

        # Desktops
        assigns = {
          "2" = [ { class = "^Firefox$"; } ];
          "9" = [ { class = "^Slack$"; } ];
        };

        # Floats
        floating.criteria = [
          { "class" = "Ibus-ui-gtk3"; }
          { "class" = "Nm-connection-editor"; }
          { "class" = "Pavucontrol"; }
          { "class" = "Pinentry"; }
          { "class" = "^.*blueman-manager.*$"; }
        ];

        # Keybindings
        inherit modifier;
        floating.modifier = "${modifier}";

        modes = {
          move = {
            Up = "${tile} top-left; mode default";
            Left = "${tile} bottom-left; mode default";
            Down = "${tile} bottom-right; mode default";
            Right = "${tile} top-right; mode default";

            Escape = "mode default";
            Return = "mode default";
            "Ctrl+g" = "mode default";
          };

          resize = {
            "h" = "resize shrink width 10 px or 10 ppt";
            "j" = "resize grow height 10 px or 10 ppt";
            "k" = "resize shrink height 10 px or 10 ppt";
            "l" = "resize grow width 10 px or 10 ppt";

            Escape = "mode default";
            Return = "mode default";
            "Ctrl+g" = "mode default";
          };
        };

        keybindings = {
          "${modifier}+r" = "mode resize";
          "${modifier}+w" = "mode move";

          # Pulse Audio controls
          "XF86AudioRaiseVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume 1 +5%";
          "XF86AudioLowerVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume 1 -5%";
          "XF86AudioMute" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-mute 1 toggle";

          # Media player controls
          "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
          "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
          "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";

          # Sreen brightness controls
          "XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -Ap 2";
          "XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -Up 2";

          # Print screen
          "Print" = "exec ${pkgs.maim}/bin/maim -i $(${pkgs.xdotool}/bin/xdotool getactivewindow) | ${pkgs.xclip}/bin/xclip -selection clipboard -t image/png";
          "${modifier}+Print" = "exec ${pkgs.maim}/bin/maim -s | ${pkgs.xclip}/bin/xclip -selection clipboard -t image/png";

          # Start a terminal
          "${modifier}+Return" = "exec i3-sensible-terminal";
          # Start program launcher
          "${modifier}+p" = "exec ${pkgs.rofi}/bin/rofi -show run";

          # Change container layout (stacked, tabbed, toggle split)
          "${modifier}+s" = "layout stacking";
          "${modifier}+t" = "layout tabbed";
          "${modifier}+e" = "layout toggle split";

          # Toggle split direction
          "${modifier}+v" = "split toggle";
          # Toggle fullscreen mode for the focused container
          "${modifier}+f" = "fullscreen toggle";
          # Toggle tiling / floating
          "${modifier}+Shift+space" = "floating toggle";

          # Scratchpad
          "${modifier}+grave" = "scratchpad show";
          "${modifier}+Shift+grave" = "move scratchpad";

          # Border
          "${modifier}+b" = "border toggle";
          # Sticky
          "${modifier}+z" = "sticky toggle";

          # PIP
          "${modifier}+Shift+z" = "mark pip,[con_mark=\"pip\"] move scratchpad,[con_mark=\"pip\"] sticky enable,resize shrink width 10000px,resize grow width 640px,resize shrink height 10000px,resize grow height 360px,move absolute position 10 px 10 px";
          # Move PIP window
          "${modifier}+Up" = "[con_mark=\"pip\"] focus,${tile} top-left && i3-msg 'focus tiling'";
          "${modifier}+Left" = "[con_mark=\"pip\"] focus,${tile} bottom-left && i3-msg 'focus tiling'";
          "${modifier}+Down" = "[con_mark=\"pip\"] focus,${tile} bottom-right && i3-msg 'focus tiling'";
          "${modifier}+Right" = "[con_mark=\"pip\"] focus,${tile} top-right && i3-msg 'focus tiling'";

          # Change focus between tiling / floating windows
          "${modifier}+space" = "focus mode_toggle";
          # Focus the parent container
          "${modifier}+a" = "focus parent";
          # Focus the child container
          "${modifier}+d" = "focus child";

          # Change focus
          "${modifier}+h" = "focus left";
          "${modifier}+j" = "focus down";
          "${modifier}+k" = "focus up";
          "${modifier}+l" = "focus right";

          # Move focused window
          "${modifier}+Shift+h" = "move left";
          "${modifier}+Shift+j" = "move down";
          "${modifier}+Shift+k" = "move up";
          "${modifier}+Shift+l" = "move right";

          # Switch to monitor
          "${modifier}+m" = "focus output up";
          # Move workspace to monitor
          "${modifier}+Shift+m" = "move workspace to output up";

          # Switch to workspace
          "${modifier}+bracketleft" = "workspace prev";
          "${modifier}+bracketright" = "workspace next";
          "${modifier}+Tab" = "workspace next";
          "${modifier}+Shift+Tab" = "workspace prev";
          "${modifier}+1" = "workspace 1";
          "${modifier}+2" = "workspace 2";
          "${modifier}+3" = "workspace 3";
          "${modifier}+4" = "workspace 4";
          "${modifier}+5" = "workspace 5";
          "${modifier}+6" = "workspace 6";
          "${modifier}+7" = "workspace 7";
          "${modifier}+8" = "workspace 8";
          "${modifier}+9" = "workspace 9";
          "${modifier}+0" = "workspace 10";

          # Move focused container to workspace
          "${modifier}+Shift+bracketleft" = "move container to workspace prev; workspace prev";
          "${modifier}+Shift+bracketright" = "move container to workspace next; workspace next";
          "${modifier}+Shift+1" = "move container to workspace 1";
          "${modifier}+Shift+2" = "move container to workspace 2";
          "${modifier}+Shift+3" = "move container to workspace 3";
          "${modifier}+Shift+4" = "move container to workspace 4";
          "${modifier}+Shift+5" = "move container to workspace 5";
          "${modifier}+Shift+6" = "move container to workspace 6";
          "${modifier}+Shift+7" = "move container to workspace 7";
          "${modifier}+Shift+8" = "move container to workspace 8";
          "${modifier}+Shift+9" = "move container to workspace 9";
          "${modifier}+Shift+0" = "move container to workspace 10";

          # Kill focused window
          "${modifier}+Shift+q" = "kill";

          # Reload the configuration file
          "${modifier}+Shift+c" = "reload";
          # Restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
          "${modifier}+Shift+r" = "restart";
          # Exit i3 (logs you out of your X session)
          "${modifier}+Shift+BackSpace" = "exec \"i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -b 'Yes, exit i3' 'i3-msg exit'\"";
        };
      };
    };
  };
}
