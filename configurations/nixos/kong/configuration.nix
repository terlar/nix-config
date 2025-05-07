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

    kernelParams = [
      "nowatchdog"
      "nmi_watchdog=0"
    ];
  };

  powerManagement.powerUpCommands = ''
    echo 1500 > /proc/sys/vm/dirty_writeback_centisecs
    echo 1 > /sys/module/snd_hda_intel/parameters/power_save
    echo med_power_with_dipm > /sys/class/scsi_host/host0/link_power_management_policy
    echo auto > /sys/bus/usb/devices/1-9/power/control
    echo auto > /sys/bus/pci/devices/0000:00:1f.2/power/control
    echo auto > /sys/bus/pci/devices/0000:00:17.0/ata1/power/control
    echo auto > /sys/bus/pci/devices/0000:00:17.0/ata2/power/control
    echo auto > /sys/bus/pci/devices/0000:00:17.0/power/control
    echo auto > /sys/bus/pci/devices/0000:00:1f.0/power/control
    echo auto > /sys/bus/pci/devices/0000:02:00.0/power/control
    echo auto > /sys/bus/pci/devices/0000:01:00.0/power/control
    echo auto > /sys/bus/pci/devices/0000:00:1d.6/power/control
    echo auto > /sys/bus/pci/devices/0000:00:00.0/power/control
    echo auto > /sys/bus/pci/devices/0000:00:1c.1/power/control
    echo auto > /sys/bus/pci/devices/0000:00:14.2/power/control
    echo auto > /sys/bus/pci/devices/0000:00:14.0/power/control
  '';

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
