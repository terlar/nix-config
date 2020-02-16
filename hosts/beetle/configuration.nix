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
    ../../modules
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
      ../../config/emacs
      ../../config/home/autorandr.nix
      ../../config/home/firefox
      ../../config/home/fish
      ../../config/home/git.nix
      ../../config/home/gtk.nix
      ../../config/home/i3.nix
      ../../config/home/kitty
      ../../config/home/qutebrowser
      ../../config/home/rofi.nix
    ] ++ lib.optionals (builtins.pathExists <private/home>) [
      <private/home>
    ];
  };

  # Keyboard preferences.
  local.keyboard = {
    enable = true;
    xkbVariant = "altgr-intl";
    xkbOptions = "lv3:ralt_switch,ctrl:nocaps";
    xkbRepeatDelay = 200;
    xkbRepeatInterval = 33; # 30Hz
  };
}
