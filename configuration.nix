{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./yubikey-gpg.nix
      ./laptop.nix
      ./gui.nix
      ./dev.nix
    ];

  hardware.bumblebee =
    { enable = true;
      pmMethod = "none";
      connectDisplay = true;
    };

  boot.blacklistedKernelModules = [ "nouveau" "bbswitch" ];

  networking.hostName = "kong";
  time.timeZone = "Europe/Stockholm";

  nixpkgs.config.allowUnfree = true;

  system.autoUpgrade.enable = true;
  system.stateVersion = "17.09";
}
