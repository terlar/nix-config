{ config, pkgs, ... }:

{
  imports = [
    ./peripheral/audio.nix
    ./peripheral/battery.nix
    ./peripheral/wireless.nix
    ./peripheral/bluetooth.nix
    ./peripheral/backlight.nix
    ./peripheral/printer.nix
  ];

  hardware.bumblebee = {
    enable = true;
    pmMethod = "none";
    connectDisplay = true;
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
  };

  boot.kernelModules = [
    "fuse"
  ];
  boot.blacklistedKernelModules = [
    "fbcon"
    "noveau"
    "bbswitch"
  ];

  # Enable touchpad support.
  services.xserver.libinput = {
    enable = true;
    disableWhileTyping = true;
    tapping = true;
    tappingDragLock = true;
    middleEmulation = true;
    naturalScrolling = true;
    scrollMethod = "twofinger";
  };

  services.xserver.videoDrivers = [ "intel" ];

  # Original dimensions: 1016x571 millimeters
  # Divided by 2 (200% scaling)
  #
  # dimensions:  3840x2160 pixels (508x282 millimeters)
  # resolution:  192x192 dots per inch
  services.xserver.monitorSection = ''
    DisplaySize 508 282
  '';
}
