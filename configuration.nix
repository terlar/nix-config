{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./hardware/dell-xps-15.nix
    ./hardware/yubikey.nix
    ./base.nix
    ./keyboard.nix
    ./editor/emacs.nix
    ./shell/fish.nix
    ./gui.nix
    ./dev.nix
  ];

  boot = {
    # Use the newer but stable kernel packages.
    kernelPackages = pkgs.linuxPackages_latest;
    # Use the systemd-boot EFI boot loader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  networking.hostName = "kong";
  networking.nameservers = [ "8.8.8.8" ];

  # Locale
  time.timeZone = "Europe/Stockholm";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.consoleKeyMap = "us";
  services.xserver.layout = "us";

  users.extraUsers.terje = {
    isNormalUser = true;
    createHome = true;
    uid = 1000;
    home = "/home/terje";
    description = "Terje Larsen";
    extraGroups = [ "wheel" "docker" ];
    shell = pkgs.fish;
  };

  system.autoUpgrade.enable = true;
  system.stateVersion = "17.09";
}
