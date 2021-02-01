{ hardware, lib, pkgs, ... }:

with builtins;

let
  name = "Terje Larsen";
  username = "terje.larsen";
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
    ../../profiles/wm/gnome3.nix
  ];

  networking.hostName = "beetle";

  # Temporary fix for tmpfs.
  systemd.additionalUpstreamSystemUnits = [ "tmp.mount" ];

  boot = {
    # Use the systemd-boot EFI boot loader.
    loader.systemd-boot.enable = true;
    # Prevent small EFI partition filling up.
    loader.systemd-boot.configurationLimit = 25;
    loader.efi.canTouchEfiVariables = true;

    # Mount tmpfs on /tmp.
    tmpOnTmpfs = true;

    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "fuse" ];
  };

  hardware = {
    enableRedistributableFirmware = true;
    opengl.enable = true;
    pulseaudio.extraConfig = ''
      .nofail
      # Apple Cinema Display (crashes PulseAudio now and then)
      set-card-profile alsa_card.usb-Apple_Inc._Display_Audio_153418EC-00 off
      .fail
    '';
  };

  services = {
    # Update support for firmware.
    fwupd.enable = true;

    printing = {
      enable = true;
      drivers = [ pkgs.gutenprint ];
    };
  };

  # System user.
  users.users.${username} = {
    description = name;
    isNormalUser = true;
    group = "users";
    extraGroups =
      [ "adbusers" "audio" "disk" "docker" "networkmanager" "video" "wheel" ];
    createHome = true;
    home = "/home/${username}";
  };

  # Managed home.
  home-manager.users.${username} = import ./home-manager;

  nix.trustedUsers = [ "root" "@wheel" ];

  # Free up to 1GiB whenever there is less than 100MiB left.
  nix.extraOptions = ''
    min-free = ${toString (100 * 1024 * 1024)}
    max-free = ${toString (1024 * 1024 * 1024)}
  '';
}
