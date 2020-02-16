{ lib, pkgs, ... }:

let
  data = import ../../load-data.nix { username = "terje"; };
in {
  imports = [
    # Hardware.
    <nixos-hardware/common/cpu/intel>
    <nixos-hardware/common/pc/laptop>
    <nixos-hardware/common/pc/ssd>
    ./hardware-configuration.nix

    ../../profiles/development.nix
    ../../profiles/laptop.nix

    # Home manager module.
    <home-manager/nixos>

    # Import local modules.
    ../../modules
  ] ++ lib.optionals (builtins.pathExists <private/nixos>) [
    <private/nixos>
  ];

  system.stateVersion = "19.09";
  networking.hostName = "kong";

  time.timeZone = "Europe/Stockholm";
  i18n.defaultLocale = "en_US.UTF-8";

  boot = rec {
    # Use the systemd-boot EFI boot loader.
    loader.systemd-boot.enable = true;
    # Prevent small EFI partition filling up.
    loader.systemd-boot.configurationLimit = 10;
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
  };

  hardware = {
    enableRedistributableFirmware = true;
    nvidiaOptimus.disable = true;
    opengl.enable = true;
  };

  services = {
    # Update support for firmware.
    fwupd.enable = true;

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
  };

  # Add my user.
  users.users."${data.username}" = {
    description = data.name;
    isNormalUser = true;
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
  home-manager.users."${data.username}" = { ... }: {
    imports = [
      ../../config/home/common.nix
      ../../config/home/gui.nix
      ../../config/emacs
    ] ++ lib.optionals (builtins.pathExists <private/home>) [
      <private/home>
    ];
  };

  # Earlier font size setup.
  console.earlySetup = true;
  # Font sizes for retina.
  fonts.fontconfig.dpi = 144;

  # Shell.
  local.shell = {
    enable = true;
    package = pkgs.fish;
  };

  # Keyboard preferences.
  local.keyboard = {
    enable = true;
    xkbVariant = "altgr-intl";
    xkbOptions = "lv3:ralt_switch,ctrl:nocaps";
    xkbRepeatDelay = 500;
    xkbRepeatInterval = 33; # 30Hz
  };
}
