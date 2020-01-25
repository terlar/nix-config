{ config, pkgs, lib, ... }:

let
  username = "terje.larsen";
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # Home manager module
    <home-manager/nixos>

    # Shared NixOS configuration.
    ../../config/nixos.nix
    ../../config/nixos/gui.nix
    ../../config/nixos/gui/i3.nix

    # Hardware configuration.
    ../../config/nixos/hardware/backlight.nix
    ../../config/nixos/hardware/battery.nix
    ../../config/nixos/hardware/yubikey.nix
  ];

  # Update support for firmware.
  services.fwupd.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use the newer but stable kernel packages.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Kernel modules:
  boot.kernelModules = [
    "fuse"
  ];
  boot.extraModulePackages = [
    config.boot.kernelPackages.sysdig
  ];

  networking.hostName = "beetle";

  # Enable network manager.
  networking.networkmanager.enable = true;

  # Disable local network name resolution.
  services.resolved.enable = false;

  # Enable zero-configuration networking and service discorvery.
  services.avahi.enable = true;
  services.avahi.nssmdns = true;

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

  # Enable OpenGL.
  hardware.opengl.enable = true;

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
  users.users."${username}" = {
    description = "Terje Larsen";
    isNormalUser = true;
    uid = 1000;
    group = "users";
    extraGroups = [
      "adbusers"
      "audio"
      "disk"
      "docker"
      "networkmanager"
      "video"
      "wheel"
    ];
    createHome = true;
    home = "/home/${username}";
  };

  # Manage home.
  home-manager.users."${username}" = import ../../config/home.nix;

  system.stateVersion = "19.09";
  system.autoUpgrade.enable = true;
}
