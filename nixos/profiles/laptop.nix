{ pkgs, ... }:

{
  imports = [ ./hardware/backlight.nix ./hardware/battery.nix ];

  networking.networkmanager.enable = true;

  hardware = {
    bluetooth.enable = true;
    pulseaudio = {
      enable = true;
      extraModules = [ pkgs.pulseaudio-modules-bt ];
      package = pkgs.pulseaudioFull;
      extraConfig = ''
        load-module module-switch-on-connect
      '';
    };
  };

  services = {
    # Enable zero-configuration networking and service discorvery.
    avahi = {
      enable = true;
      nssmdns = true;
    };

    # Improve touch-pad behavior.
    xserver.libinput = {
      disableWhileTyping = true;
      tapping = false;
      tappingDragLock = false;
      middleEmulation = true;
      naturalScrolling = true;
      scrollMethod = "twofinger";
    };

    # Monitor and control temperature.
    thermald.enable = true;
  };
}
