{ config, pkgs, lib, ... }:

let
  username = "terje";
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
  ] ++ lib.optional (builtins.pathExists ../../private/nixos.nix) ../../private/nixos.nix;

  # Update support for firmware.
  services.fwupd.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Prevent system freezes.
  boot.kernelParams = [
    "acpi_rev_override=1"
    "nouveau.modeset=0"
    "pcie_aspm=off"
  ];
  # Use the newer but stable kernel packages.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Kernel modules:
  boot.kernelModules = [ "fuse" ];
  boot.blacklistedKernelModules = [ "nouveau" ];
  boot.extraModulePackages = [
    config.boot.kernelPackages.sysdig
  ];

  networking.hostName = "kong";

  # Enable network manager.
  networking.networkmanager.enable = true;

  # Enable network name resolution.
  services.resolved.enable = true;

  # Enable zero-configuration networking and service discorvery.
  services.avahi.enable = true;
  services.avahi.nssmdns = true;

  # Font sizes for retina.
  fonts.fontconfig.dpi = 144;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.cups-bjnp pkgs.gutenprint pkgs.gutenprintBin ];

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
    package = pkgs.pulseaudioFull;
  };

  # Enable bluetooth support.
  hardware.bluetooth.enable = true;

  # Disable Nvidia graphics card.
  hardware.nvidiaOptimus.disable = true;

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

  # Enable docker support.
  virtualisation.docker.enable = true;

  # Add my user.
  users.extraUsers."${username}" = {
    description = "Terje Larsen";
    isNormalUser = true;
    uid = 1000;
    group = "users";
    extraGroups = [
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
