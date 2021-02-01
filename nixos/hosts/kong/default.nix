{ hardware, lib, pkgs, ... }:

with builtins;

let
  name = "Terje Larsen";
  username = "terje";
in {
  imports = [
    # Hardware.
    ./hardware-configuration.nix
    "${hardware}/common/cpu/intel"
    "${hardware}/common/pc/laptop"
    "${hardware}/common/pc/ssd"

    ../../profiles/common.nix
    ../../profiles/graphical.nix
    ../../profiles/laptop.nix

    ../../profiles/appearance/high-contrast.nix
    ../../profiles/development/docker.nix
    ../../profiles/development/sysdig.nix
    ../../profiles/wm/gnome3.nix
  ];

  system.stateVersion = "19.09";
  networking.hostName = "kong";

  boot = {
    # Use the systemd-boot EFI boot loader.
    loader.systemd-boot.enable = true;
    # Prevent small EFI partition filling up.
    loader.systemd-boot.configurationLimit = 25;
    loader.efi.canTouchEfiVariables = true;

    kernelPackages = pkgs.linuxPackages_latest;

    # Prevent system freezes.
    kernelParams =
      [ "acpi_rev_override=1" "nouveau.modeset=0" "pcie_aspm=off" ];

    kernelModules = [ "fuse" ];
    blacklistedKernelModules = [ "nouveau" ];
  };

  hardware = {
    enableRedistributableFirmware = true;
    nvidiaOptimus.disable = true;
    opengl.enable = true;
  };

  services = {
    # Update support for firmware.
    fwupd.enable = true;

    printing = {
      enable = true;
      drivers = [ pkgs.cups-bjnp pkgs.gutenprint pkgs.gutenprintBin ];
    };

    # Enable network name resolution.
    resolved.enable = true;
  };

  # System user.
  users.users.${username} = {
    description = name;
    isNormalUser = true;
    group = "users";
    extraGroups = [ "audio" "disk" "docker" "networkmanager" "video" "wheel" ];
    createHome = true;
    home = "/home/${username}";
  };

  # Managed home.
  home-manager.users.${username} = import ./home-manager;

  nix.gc = {
    automatic = true;
    dates = "12:12";
  };

  # Earlier font size setup.
  console.earlySetup = true;
  # Font sizes for retina.
  fonts.fontconfig.dpi = 144;
}
