{ pkgs, ... }:
let
  name = "Terje Larsen";
  username = "terje";
in
{
  system.stateVersion = "19.09";
  networking.hostName = "kong";

  profiles = {
    console.enable = true;
    iphone.enable = true;
    yubikey.enable = true;

    user.terje = {
      graphical = {
        enable = true;
        desktop = true;
      };
      laptop.enable = true;
    };
  };

  boot = {
    loader = {
      systemd-boot = {
        # Use the systemd-boot EFI boot loader.
        enable = true;
        # Prevent small EFI partition filling up.
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };

    kernelModules = [ "fuse" ];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  services = {
    # Update support for firmware.
    fwupd.enable = true;

    # Fingerprint reader
    fprintd.enable = false;

    # Printing
    printing = {
      enable = true;
      drivers = [
        pkgs.gutenprint
      ];
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
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    createHome = true;
    home = "/home/${username}";
  };

  # Managed home.
  home-manager.users.${username} = {
    home.stateVersion = "20.09";

    profiles.user.terje = {
      desktop = {
        enable = true;
        enableCommunicationPackages = true;
        enableMediaPackages = true;
      };
      keyboards.enable = true;
    };

    services.ollama = {
      enable = true;
      package = pkgs.ollama-cuda;
      environmentVariables = {
        OLLAMA_FLASH_ATTENTION = "1";
      };
    };
  };

  # Hi-DPI
  console.earlySetup = true;
  environment.sessionVariables.GDK_SCALE = "1";
}
