{ config, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    autorun = true;
  };

  environment = {
    systemPackages = with pkgs; [
      xclip
      xsel
      feh
      gnome3.gcr
    ];
  };
}
