{ lib, pkgs, ... }:

let
  data = import ../../load-data.nix { username = "terje"; };
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    <nixos-hardware/common/cpu/intel>
    <nixos-hardware/common/pc/laptop>
    <nixos-hardware/common/pc/ssd>

    ../../config/nixos/backlight.nix
    ../../config/nixos/base.nix
    ../../config/nixos/battery.nix
    ../../config/nixos/docker.nix
    ../../config/nixos/fonts.nix
    ../../config/nixos/gui.nix
    ../../config/nixos/gui/i3.nix
    ../../config/nixos/yubikey.nix

    # Home manager module
    <home-manager/nixos>

    # Import local modules
    ../../modules
  ] ++ lib.optionals (builtins.pathExists <private/nixos>) [
    <private/nixos>
  ];

  system.stateVersion = "19.09";
  networking.hostName = "kong";

  # Update support for firmware.
  services.fwupd.enable = true;

  boot = rec {
    # Use the systemd-boot EFI boot loader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    kernelPackages = pkgs.linuxPackages_latest;

    # Prevent system freezes.
    kernelParams = [
      "acpi_rev_override=1"
      "nouveau.modeset=0"
      "pcie_aspm=off"
    ];

    kernelModules = [ "fuse" ];
    blacklistedKernelModules = [ "nouveau" ];
    extraModulePackages = [
      kernelPackages.sysdig
    ];
  };

  hardware = {
    cpu.intel.updateMicrocode = true;
    enableRedistributableFirmware = true;

    nvidiaOptimus.disable = true;

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

    kmonad = {
      enable = true;
      extraConfig = builtins.readFile ./kmonad.kbd;
    };

    printing = {
      enable = true;
      drivers = [ pkgs.cups-bjnp pkgs.gutenprint pkgs.gutenprintBin ];
    };

    # Enable network name resolution.
    resolved.enable = true;

    # Monitor and control temperature.
    thermald.enable = true;

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
  users.extraUsers."${data.username}" = {
    description = data.name;
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
    home = "/home/${data.username}";
  };

  # Manage home.
  home-manager.users."${data.username}" = import ../../config/home.nix;

  # Enable super user handling.
  security.sudo.enable = true;

  time.timeZone = "Europe/Stockholm";
  i18n.defaultLocale = "en_US.UTF-8";

  # Keyboard preferences.
  local.keyboard = {
    enable = true;
    xkbVariant = "altgr-intl";
    xkbOptions = "lv3:ralt_switch,ctrl:nocaps";
    xkbRepeatDelay = 500;
    xkbRepeatInterval = 33; # 30Hz
  };

  # Font sizes for retina.
  fonts.fontconfig.dpi = 144;
}
