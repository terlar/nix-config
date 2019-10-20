{ config, pkgs, ... }:

{
  services.xserver = {
    windowManager = {
      i3 = {
        enable = true;
        package = pkgs.i3-gaps;
      };
      default = "i3";
    };

    desktopManager = {
      xterm.enable = false;
    };
  };

  services.compton.enable = true;
  
  environment.systemPackages = with pkgs; [
    dex
    xssproxy
  ];
}
