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
      alacritty
      kitty
      dropbox-cli
      paper-gtk-theme
      paper-icon-theme
      gnome2.gtk
      gnome3.gtk
      gnome3.gcr
      pinentry_gnome
    ];

    shellInit = "
      export QT_STYLE_OVERRIDE=HighContrast
      export GTK_THEME=HighContrast
      export GTK_PATH=$GTK_PATH:${pkgs.gnome2.gtk}/lib/gtk-2.0
      export GTK2_RC_FILES=$GTK2_RC_FILES:${pkgs.gnome2.gtk}/share/themes/HighContrast/gtk-2.0/gtkrc
    ";
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
    displayManager.lightdm.enable = true;
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
    };

    monitorSection = "
      DisplaySize 508 282
    ";
  };

  # Permission escalation
  security.polkit.enable = true;

  # Auto-mount
  services.udisks2.enable = true;

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
