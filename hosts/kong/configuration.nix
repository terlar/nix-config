{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # Shared NixOS configuration.
      ../../config/nixos.nix
      ../../config/nixos/gui.nix

      # Hardware configuration.
      ../../config/nixos/hardware/audio.nix
      ../../config/nixos/hardware/backlight.nix
      ../../config/nixos/hardware/battery.nix
      ../../config/nixos/hardware/bluetooth.nix
      ../../config/nixos/hardware/wireless.nix
      ../../config/nixos/hardware/yubikey.nix
    ];


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use the newer but stable kernel packages.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Kernel modules:
  boot.kernelModules = [
    "fuse"
  ];
  boot.blacklistedKernelModules = [
    "fbcon"
    "noveau"
    "bbswitch"
  ];

  networking.hostName = "kong";
  # Disable IPv6 due to resolving issues.
  networking.enableIPv6 = false;

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

  # Add my user.
  users.extraUsers.terje = {
    createHome = true;
    extraGroups = [ "wheel" "docker" ];
    group = "users";
    home = "/home/terje";
    description = "Terje Larsen";
    shell = pkgs.fish;
    isNormalUser = true;
    uid = 1000;
  };

  system.stateVersion = "18.09";
  system.autoUpgrade.enable = true;
}
