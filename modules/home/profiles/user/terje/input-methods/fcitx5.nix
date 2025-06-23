{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.profiles.user.terje.inputMethods.fcitx5;
in
{
  options.profiles.user.terje.inputMethods.fcitx5 = {
    enable = lib.mkEnableOption "fcitx Input Method Editor configuration for Terje";
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.niri.spawnAtStartup = [ "fcitx5" ];

    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        addons = [ pkgs.fcitx5-chinese-addons ];

        waylandFrontend = lib.mkDefault true;
        settings = {
          globalOptions = {
            "PreeditEnabledByDefault"."0" = true;
            "Hotkey"."EnumrateWithTriggerKeys" = false;
            "Hotkey/TriggerKeys"."0" = "Control+Shift+space";
            "Hotkey/AltTriggerKeys"."0" = "Shift_L";
            "Hotkey/EnumerateForwardKeys"."0" = "";
            "Hotkey/EnumerateBackwardKeys"."0" = "";
          };
          inputMethod = {
            "Groups/0" = {
              Name = "Default";
              "Default Layout" = "us";
              DefaultIM = "keyboard-us";
            };
            "Groups/0/Items/0" = {
              Name = "keyboard-us";
              Layout = "";
            };
            "Groups/0/Items/1" = {
              Name = "pinyin";
              Layout = "";
            };
            "Groups/0/Items/2" = {
              Name = "keyboard-cn-tib";
              Layout = "";
            };
            GroupOrder."0" = "Default";
          };

          addons = {
            pinyin = {
              globalSection = {
                CloudPinyinEnabled = true;
                CloudPinyinIndex = 2;
                PreeditInApplication = true;
              };
            };
            cloudpinyin.globalSection = {
              Backend = "Baidu";
              MinimumPinyinLength = 4;
            };
            clipboard.sections.TriggerKey = { };
          };
        };
      };
    };
  };
}
