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

  hardware = {
    enableRedistributableFirmware = true;
    graphics.enable = true;
    nvidia = {
      modesetting.enable = true;
      nvidiaSettings = false;
    };
  };

  services = {
    # Update support for firmware.
    fwupd.enable = true;

    # Fingerprint reader
    fprintd.enable = false;

    printing = {
      enable = true;
      drivers = [
        pkgs.cups-bjnp
        pkgs.gutenprintBin
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
      keyboards.enable = true;
      graphical = {
        enable = true;
        desktop = true;
      };
    };

    services.ollama = {
      enable = true;
      acceleration = "cuda";
    };
  };

  # Hi-DPI
  console.earlySetup = true;
  environment.sessionVariables.GDK_SCALE = "1";
}
