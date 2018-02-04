{ config, lib, pkgs, ... }:

{
  hardware.bluetooth.enable = true;

  boot =
    { # Use the latest kernel packages.
      kernelPackages = pkgs.linuxPackages_latest;
      # Use the systemd-boot EFI boot loader.
      loader.systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;
    };

  networking =
    { nameservers = [ "8.8.8.8" ];
      wireless.enable = true;
    };

  environment.systemPackages = with pkgs;
    [ mkpasswd
      git
      git-lfs
      gitAndTools.hub
      gitAndTools.ghq
      gnumake
      stow
      curl
      wget
      emacs
      fish
      tree
      most
      ripgrep
    ];

  programs =
    { bash.enableCompletion = true;
      fish.enable = true;
    };

  services =
    { ntp.enable = true;
      printing.enable = true;

      kmscon =
        { enable = true;
          hwRender = true;
          extraConfig =
            ''
            palette=solarized-white
            font-name=Fira Mono
            font-size=20
            xkb-variant=altgr-intl
            xkb-options=lv3:ralt_switch,ctrl:nocaps
            xkb-repeat-delay=200
            xkb-repeat-rate=25
            '';
        };

      dnsmasq =
        { enable = true;
          servers = [ "127.0.0.1#43" ];
        };
    };

  users.defaultUserShell = pkgs.fish;
  users.extraUsers.terje =
    { isNormalUser = true;
      createHome = true;
      uid = 1000;
      home = "/home/terje";
      description = "Terje Larsen";
      extraGroups = [ "wheel" ];
      shell = pkgs.fish;
    };
}
