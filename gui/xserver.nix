{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    autorun = true;
  };

  environment = {
    systemPackages = with pkgs; [
      libnotify
      xfce.xfce4-notifyd
      xclip
      xsel
      feh
      gnome3.gcr
    ];
  };
}
