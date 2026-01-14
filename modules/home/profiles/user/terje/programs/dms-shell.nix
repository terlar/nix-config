{ config, lib, ... }:

let
  cfg = config.profiles.user.terje.programs.dms-shell;
in
{
  options.profiles.user.terje.programs.dms-shell = {
    enable = lib.mkEnableOption "Dank Material Shell configuration for Terje";
  };

  config = lib.mkIf cfg.enable {
    programs.dms-shell = {
      enable = true;
      settings = {
        barConfigs = [
          {
            id = "default";
            name = "Main Bar";
            enabled = true;
            position = 0;
            screenPreferences = [ "all" ];
            showOnLastDisplay = true;
            leftWidgets = [
              "launcherButton"
              "workspaceSwitcher"
              "focusedWindow"
            ];
            centerWidgets = [
              "music"
              "clock"
              "weather"
            ];
            rightWidgets = [
              "systemTray"
              "clipboard"
              "cpuUsage"
              "memUsage"
              "notificationButton"
              "battery"
              "controlCenterButton"
            ];
            spacing = 0;
            innerPadding = 7;
            bottomGap = 0;
            transparency = 0;
            widgetTransparency = 0.75;
            squareCorners = false;
            noBackground = false;
            gothCornersEnabled = false;
            gothCornerRadiusOverride = false;
            gothCornerRadiusValue = 12;
            borderEnabled = false;
            borderColor = "surfaceText";
            borderOpacity = 1;
            borderThickness = 1;
            widgetOutlineEnabled = false;
            widgetOutlineColor = "primary";
            widgetOutlineOpacity = 1;
            widgetOutlineThickness = 1;
            fontScale = 1;
            autoHide = false;
            autoHideDelay = 250;
            openOnOverview = false;
            visible = true;
            popupGapsAuto = true;
            popupGapsManual = 4;
            maximizeDetection = true;
          }
        ];
      };
    };
  };
}
