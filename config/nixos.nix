{ config, lib, pkgs, ... }:

let
  keyboardLayout = "us";
  xkbVariant = "altgr-intl";
  xkbOptions = "lv3:ralt_switch,ctrl:nocaps";
  repeatDelay = 200;
  repeatInterval = 33; # 30Hz
  nixosUnstable = builtins.fetchTarball https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz;
in {
  imports = [
    ./common.nix
  ] ++ lib.optional (builtins.pathExists <private/nixos>) <private/nixos> ;

  nix = {
    gc.automatic = true;
    gc.dates = "12:12";
  };

  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = keyboardLayout;

  # Enable super user handling.
  security.sudo.enable = true;

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;

    fonts = import ./fonts.nix { inherit pkgs; };

    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [
          "Iosevka Slab"
          "Noto Sans Mono CJK SC"
          "Noto Emoji"
          "Noto Sans Symbols"
        ];
        sansSerif = [
          "Noto Sans"
          "Noto Sans CJK SC"
          "Noto Emoji"
          "Noto Sans Symbols"
        ];
        serif = [
          "Noto Serif"
          "Noto Sans CJK SC"
          "Noto Emoji"
          "Noto Sans Symbols"
        ];
      };
    };
  };

  programs = {
    command-not-found.dbPath = "${nixosUnstable}/programs.sqlite";

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  services = {
    # Time management.
    ntp.enable = true;

    # Virtual terminal.
    kmscon = {
      enable = true;
      hwRender = true;
      extraConfig = ''
        palette=solarized-white
        font-name=Iosevka Slab
        font-size=16
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

    # IRC gateway for message services.n
    bitlbee = {
      enable = true;
      plugins = [
        pkgs.bitlbee-facebook
      ];
      libpurple_plugins = [
        pkgs.purple-hangouts
        pkgs.telegram-purple
      ];
    };
  };

  users.defaultUserShell = pkgs.fish;
}
