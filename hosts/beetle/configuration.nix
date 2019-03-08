{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # Shared NixOS configuration.
      ../../config/nixos.nix
      ../../config/nixos/gui.nix
      ../../config/nixos/gui/i3.nix

      # Hardware configuration.
      ../../config/nixos/hardware/backlight.nix
      ../../config/nixos/hardware/battery.nix
      ../../config/nixos/hardware/yubikey.nix
    ] ++ lib.optional (builtins.pathExists ./private/nixos.nix) ./private/nixos.nix;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Encrpytion for root partition.
  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/disk/by-uuid/77e2f8f5-4799-4e86-9318-cb61589b8f89";
      preLVM = true;
    }
  ];

  # Use the newer but stable kernel packages.
  boot.kernelPackages = pkgs.linuxPackages_4_20;

  # Kernel modules:
  boot.kernelModules = [
    "fuse"
  ];
  boot.extraModulePackages = [
    config.boot.kernelPackages.sysdig
  ];

  networking.hostName = "beetle";
  # Disable IPv6 due to resolving issues.
  networking.enableIPv6 = false;

  # Enable network manager.
  networking.networkmanager.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.gutenprint ];

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
    package = pkgs.pulseaudioFull;
  };

  # Enable bluetooth support.
  hardware.bluetooth.enable = true;

  # Enable touchpad support.
  services.xserver.libinput = {
    enable = true;
    disableWhileTyping = true;
    tapping = false;
    tappingDragLock = false;
    middleEmulation = true;
    naturalScrolling = true;
    scrollMethod = "twofinger";
  };

  # Enable docker support.
  virtualisation.docker = {
    enable = true;
    extraOptions = "--experimental=true";
  };

  # Add my user.
  users.users."terje.larsen" = {
    description = "Terje Larsen";
    createHome = true;
    extraGroups = [
      "adbusers"
      "audio"
      "disk"
      "docker"
      "networkmanager"
      "video"
      "wheel"
    ];
    group = "users";
    home = "/home/terje.larsen";
    isNormalUser = true;
    uid = 1000;
  };

  system.stateVersion = "18.09";
  system.autoUpgrade.enable = true;
}
