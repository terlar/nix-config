{ config, pkgs, ... }:

let
  keyboardLayout = "us";
  xkbVariant     = "altgr-intl";
  xkbOptions     = "lv3:ralt_switch,ctrl:nocaps";
  repeatDelay    = 200;
  repeatInterval = 33; # 30Hz
in {
  imports = [
    ./common.nix
  ];

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.consoleKeyMap = keyboardLayout;

  # Enable super user handling.
  security.sudo.enable = true;

  # Use Systemd for network management.
  networking.useNetworkd = true;

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;

    fonts = import ./fonts.nix { inherit pkgs; };

    fontconfig = {
      enable = true;
      dpi = 180;
      defaultFonts = {
        monospace = [ "Iosevka Slab" ];
        sansSerif = [ "Noto Sans" ];
        serif     = [ "Noto Serif" ];
      };
    };
  };

  services = {
    # Time management.
    ntp.enable = true;

    # Local DNS cache.
    dnsmasq = {
      enable = true;
      servers = [ "127.0.0.1#43" ];
    };

    # Virtual terminal.
    kmscon = {
      enable = true;
      hwRender = true;
      extraConfig = ''
        palette=solarized-white
        font-name=Iosevka Slab
        font-size=20
        xkb-variant=${xkbVariant}
        xkb-options=${xkbOptions}
        xkb-repeat-delay=${toString repeatDelay}
        xkb-repeat-rate=${toString repeatInterval}
      '';
    };

    # Xorg config.
    xserver = {
      layout = keyboardLayout;
      xkbVariant = xkbVariant;
      xkbOptions = xkbOptions;
      autoRepeatDelay = repeatDelay;
      autoRepeatInterval = repeatInterval;
    };

    # Auto-mount disks.
    udisks2.enable = true;
  };

  users.defaultUserShell = pkgs.fish;
}
