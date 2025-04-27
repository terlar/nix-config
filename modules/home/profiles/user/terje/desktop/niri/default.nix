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
      pkgs.wireplumber
    ];

    programs = {
      fuzzel.enable = true;
      swaylock.enable = true;
      waybar.enable = true;
    };

    wayland.windowManager.niri = {
      enable = true;

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
          "Mod+Space".spawn = "fuzzel";
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

          XF86AudioRaiseVolume = {
            _props.allow-when-locked = true;
            spawn = [
              "wpctl"
              "set-volume"
              "@DEFAULT_AUDIO_SINK@"
              "0.1+"
            ];
          };
          XF86AudioLowerVolume = {
            _props.allow-when-locked = true;
            spawn = [
              "wpctl"
              "set-volume"
              "@DEFAULT_AUDIO_SINK@"
              "0.1-"
            ];
          };
          XF86AudioMute = {
            _props.allow-when-locked = true;
            spawn = [
              "wpctl"
              "set-mute"
              "@DEFAULT_AUDIO_SINK@"
              "toggle"
            ];
          };
          XF86AudioMicMute = {
            _props.allow-when-locked = true;
            spawn = [
              "wpctl"
              "set-mute"
              "@DEFAULT_AUDIO_SOURCE@"
              "toggle"
            ];
          };
        };
      };

      extraConfig = ''
        spawn-at-startup "waybar"
      '';
    };
  };
}
