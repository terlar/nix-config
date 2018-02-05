{ config, lib, pkgs, ... }:

{
  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [ libpinyin ];
  };

  environment = {
    systemPackages = with pkgs; [
      rofi
      xclip
      slop
      maim
      imagemagick
      feh
      firefox
      qutebrowser
      termite
      alacritty
      hyper
      dropbox-cli
      kde-gtk-config
      numix-gtk-theme
      paper-gtk-theme
      paper-icon-theme
    ];

    shellInit = ''
      export GTK_PATH=$GTK_PATH:${pkgs.numix-gtk-theme}/lib/gtk-2.0
      export GTK2_RC_FILES=$GTK2_RC_FILES:${pkgs.numix-gtk-theme}/share/themes/Numix/gtk-2.0/gtkrc
    '';
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    autorun = true;

    videoDrivers = [ "intel" ];

    # Keyboard
    layout = "us";
    xkbVariant = "altgr-intl";
    xkbOptions = "lv3:ralt_switch,ctrl:nocaps";

    # Enable touchpad support.
    libinput = {
      enable = true;
      naturalScrolling = true;
      disableWhileTyping = true;
    };

    # Enable desktop environment.
    desktopManager = {
      gnome3.enable = true;
      default = "gnome3";
    };
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
    };

    monitorSection = ''
      DisplaySize 508 284
    '';
  };

  # Setup fonts
  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      unifont
      symbola
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      fira
      fira-mono
      fira-code
      fantasque-sans-mono
      emojione
      emacs-all-the-icons-fonts
      source-han-sans-simplified-chinese
      source-han-sans-traditional-chinese
    ];
  };
}
