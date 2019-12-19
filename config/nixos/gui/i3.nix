{ config, pkgs, ... }:

{
  services.autorandr.enable = true;

  services.xserver = {
    enable = true;
    autorun = true;

    # Start a DBus session.
    startDbusSession = true;

    windowManager = {
      i3 = {
        enable = true;
        package = pkgs.i3-gaps;
      };
    };

    desktopManager = {
      xterm.enable = false;
    };

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
