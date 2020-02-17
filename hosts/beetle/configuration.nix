{ lib, pkgs, ... }:

let
  data = import ../../load-data.nix {};
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
    ../../modules/nixos
  ] ++ lib.optionals (builtins.pathExists <private/nixos>) [
    <private/nixos>
  ];

  system.stateVersion = "19.09";
  networking.hostName = "beetle";

  time.timeZone = "Europe/Stockholm";
  i18n.defaultLocale = "en_US.UTF-8";

  boot = rec {
    # Use the systemd-boot EFI boot loader.
    loader.systemd-boot.enable = true;
    # Prevent small EFI partition filling up.
    loader.systemd-boot.configurationLimit = 10;
    loader.efi.canTouchEfiVariables = true;

    kernelPackages = pkgs.linuxPackages_latest;

    kernelModules = [ "fuse" ];
  };

  hardware = {
    enableRedistributableFirmware = true;
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
      drivers = [ pkgs.gutenprint ];
    };
  };

  # Add my user.
  users.users."${data.username}" = {
    description = data.name;
    isNormalUser = true;
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
  home-manager.users."${data.username}" = { ... }: {
    imports = [
      ../../config/home/common.nix
      ../../config/home/gui.nix
      ../../config/home/emacs

      # Import local modules.
      ../../modules/home
    ] ++ lib.optionals (builtins.pathExists <private/home>) [
      <private/home>
    ];
  };

  # Dictionaries.
  local.dictionaries = {
    enable = true;
    languages = ["en-us" "sv-se"];
  };

  # Keyboard preferences.
  local.keyboard = {
    enable = true;
    xkbVariant = "altgr-intl";
    xkbOptions = "lv3:ralt_switch,ctrl:nocaps";
    xkbRepeatDelay = 340;
    xkbRepeatInterval = 170;
  };

  # Shell.
  local.shell = {
    enable = true;
    package = pkgs.fish;
  };
}
