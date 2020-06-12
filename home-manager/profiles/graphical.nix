{ pkgs, ... }:

{
  imports =
    [ ./programs/kitty.nix ./programs/qutebrowser.nix ./programs/rofi.nix ];

  home.packages = with pkgs; [
    scripts.lock
    scripts.logout
    scripts.window_tiler

    # application
    krita
    mpv
    slack
    spotify
    sxiv

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
