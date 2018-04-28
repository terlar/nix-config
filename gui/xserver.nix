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
      libnotify
      xclip
      xfce.xfce4-notifyd
      xorg.xhost
      xsel
    ];
  };
}
