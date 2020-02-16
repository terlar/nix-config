{ config, pkgs, ... }:

{
  services.autorandr.enable = true;

  services.xserver = {
    enable = true;
    autorun = true;

    # Start a DBus session.
    startDbusSession = true;

    desktopManager.xterm.enable = false;
    windowManager.i3.enable = true;

    displayManager = {
      defaultSession = "none+i3";
      lightdm = {
        enable = true;
        greeters.gtk.enable = true;
      };
    };
  };

  services.compton.enable = true;
  
  environment.systemPackages = with pkgs; [
    dex
    xssproxy
  ];
}
