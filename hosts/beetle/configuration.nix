{ pkgs, ... }:

let
  data = import ../../load-data.nix {};
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

  system.stateVersion = "19.09";
  networking.hostName = "beetle";

  # Update support for firmware.
  services.fwupd.enable = true;

  boot = rec {
    # Use the systemd-boot EFI boot loader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    kernelPackages = pkgs.linuxPackages_latest;

    kernelModules = [ "fuse" ];
    extraModulePackages = [
      kernelPackages.sysdig
    ];
  };

  hardware = {
    cpu.intel.updateMicrocode = true;
    enableRedistributableFirmware = true;

    bluetooth.enable = true;
    opengl.enable = true;
    pulseaudio = {
      enable = true;
      extraModules = [ pkgs.pulseaudio-modules-bt ];
      package = pkgs.pulseaudioFull;
    };
  };

  networking.networkmanager.enable = true;

  system.autoUpgrade.enable = true;

  services = {
    # Enable zero-configuration networking and service discorvery.
    avahi = {
      enable = true;
      nssmdns = true;
    };

    printing = {
      enable = true;
      drivers = [ pkgs.gutenprint ];
    };

    # Enable touchpad support.
    xserver.libinput = {
      enable = true;
      disableWhileTyping = true;
      tapping = false;
      tappingDragLock = false;
      middleEmulation = true;
      naturalScrolling = true;
      scrollMethod = "twofinger";
    };
  };

  # Add my user.
  users.users."${data.username}" = {
    description = data.name;
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
    home = "/home/${data.username}";
  };

  # Manage home.
  home-manager.users."${data.username}" = import ../../config/home.nix;

  # Docker support.
  virtualisation.docker = {
    enable = true;
    extraOptions = "--experimental=true";
  };
}
