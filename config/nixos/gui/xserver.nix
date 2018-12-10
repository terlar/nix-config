{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    autorun = true;
  };

  environment = {
    systemPackages = with pkgs; [
      feh
      gnome3.gcr
      kitty
      libnotify
      rofi
      xclip
      xfce.xfce4-notifyd
      xorg.xhost
      xsel
    ];
  };
}
