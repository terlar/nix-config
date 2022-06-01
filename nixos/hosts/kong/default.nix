{ lib, pkgs, ... }:

with builtins;
let
  name = "Terje Larsen";
  username = "terje";
in
{
  system.stateVersion = "19.09";
  networking.hostName = "kong";

  imports = [
    ./hardware-configuration.nix

    ../../profiles/common.nix
    ../../profiles/graphical.nix
    ../../profiles/laptop.nix

    ../../profiles/appearance/high-contrast.nix
    ../../profiles/development/docker.nix
    ../../profiles/development/sysdig.nix
    ../../profiles/wm/gnome.nix
  ];

  boot = {
    # Use the systemd-boot EFI boot loader.
    loader.systemd-boot.enable = true;
    # Prevent small EFI partition filling up.
    loader.systemd-boot.configurationLimit = 25;
    loader.efi.canTouchEfiVariables = true;

    kernelModules = [ "fuse" ];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  hardware = {
    enableRedistributableFirmware = true;
    opengl.enable = true;

    # Disable the disable, as this enables the broken bbswitch.
    nvidiaOptimus.disable = false;
  };

  services = {
    # Update support for firmware.
    fwupd.enable = true;

    printing = {
      enable = true;
      drivers = [ pkgs.cups-bjnp pkgs.gutenprint pkgs.gutenprintBin ];
    };

    # Enable network name resolution.
    resolved = {
      enable = true;
      extraConfig = ''
        DNS=1.1.1.1
      '';
    };
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

  nix.settings.trusted-users = [ "root" username ];

  nix.gc = {
    automatic = true;
    dates = "12:12";
  };

  # Earlier font size setup.
  console.earlySetup = true;
}
