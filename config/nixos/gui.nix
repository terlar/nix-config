{ config, pkgs, ... }:

{
  imports = [
    ./gui/theme.nix
    ./gui/ibus.nix
  ];

  # Graphical boot process.
  boot.plymouth.enable = true;

  # Permission escalation.
  security.polkit.enable = true;

  # Enable secrets store.
  services.gnome3.gnome-keyring.enable = true;
  security.pam.services.lightdm.enableGnomeKeyring = true;

  environment.systemPackages = with pkgs; [
    scripts.emacseditor
    scripts.emacsmail
    scripts.insomnia
    scripts.lock
    scripts.logout
    scripts.themepark
    scripts.window_tiler

    # appearance
    gnome2.gtk
    gnome3.gtk
    gnome-themes-extra
    paper-gtk-theme
    paper-icon-theme

    # applications
    firefox
    kitty
    krita
    luakit
    mpv
    qutebrowser
    slack
    spotify
    sxiv

    # desktop
    gnome3.gcr
    gnome3.gnome-keyring
    gnome3.seahorse
    libgnome-keyring
    libnotify
    networkmanagerapplet
    pavucontrol
    xfce.xfce4-notifyd

    # utility
    feh
    imagemagick
    maim
    peek
    rofi
    slop
    xautolock
    xcalib
    xclip
    xorg.xhost
    xsel
    xss-lock
  ];
}
