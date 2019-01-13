{ config, pkgs, ... }:

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
    ];

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
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Kernel modules:
  boot.kernelModules = [
    "fuse"
  ];

  networking.hostName = "beetle";
  # Disable IPv6 due to resolving issues.
  networking.enableIPv6 = false;

  # Enable network manager.
  networking.networkmanager.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

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
  services.xserver.libinput.enable = true;

  # Add my user.
  users.users."terje.larsen" = {
    createHome = true;
    extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" "docker" ];
    group = "users";
    home = "/home/terje.larsen";
    isNormalUser = true;
    uid = 1000;
  };

  system.stateVersion = "18.09";
  system.autoUpgrade.enable = true;
}
