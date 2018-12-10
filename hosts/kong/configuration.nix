{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # Shared NixOS configuration.
    ../../config/nixos.nix
  ];

  system.stateVersion = "18.09";
  system.autoUpgrade.enable = true;

  networking.hostName = "kong";
  networking.enableIPv6 = false;

  boot = {
    # Use the systemd-boot EFI boot loader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    # Use the newer but stable kernel packages.
    kernelPackages = pkgs.linuxPackages_latest;

    # Kernel modules:
    kernelModules = [
      "fuse"
    ];
    blacklistedKernelModules = [
      "fbcon"
      "noveau"
      "bbswitch"
    ];
  };

  # Update support for firmware.
  services.fwupd.enable = true;

  # Enable Intel video drivers.
  services.xserver.videoDrivers = [ "intel" ];

  # Dual graphic cards support.
  hardware.bumblebee = {
    enable = true;
    pmMethod = "none";
    connectDisplay = true;
  };

  # OpenGL settings.
  hardware.opengl = {
    enable = true;
    driSupport = true;
  };

  # Original dimensions: 1016x571 millimeters
  # Divided by 2 (200% scaling)
  #
  # dimensions:  3840x2160 pixels (508x286 millimeters)
  # resolution:  192x192 dots per inch
  services.xserver.monitorSection = ''
    DisplaySize 508 286
  '';

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
}
