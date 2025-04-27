{ lib, pkgs, ... }:
let
  gpg-agent-conf = pkgs.writeText "gpg-agent.conf" ''
    pinentry-program ${pkgs.pinentry-curses}/bin/pinentry-curses
  '';
in
lib.mkMerge [
  # Required packages and services.
  {
    services = {
      pcscd.enable = true;
      udev.packages = [ pkgs.yubikey-personalization ];
    };
    environment.systemPackages = [
      pkgs.gnupg
      pkgs.paperkey
      pkgs.wget

      # pkgs.haskellPackages.hopenpgp-tools
      pkgs.yubikey-manager

      pkgs.zellij
      pkgs.drduh-yubikey-guide
    ];

    programs = {
      ssh.startAgent = false;
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
    };
  }

  # Avoid accidental persistence to USB-drive
  { boot.kernelParams = [ "copytoram" ]; }

  # Disable networking
  {
    boot.initrd.network.enable = false;
    networking = {
      dhcpcd = {
        enable = false;
        allowInterfaces = [ ];
      };
      firewall.enable = true;
      useDHCP = false;
      useNetworkd = false;
      wireless.enable = false;
    };
  }

  # Secure defaults.
  {
    boot = {
      tmp.cleanOnBoot = true;
      kernel.sysctl = {
        "kernel.unprivileged_bpf_disabled" = 1;
      };
    };
  }

  # Set up the shell for making keys.
  {
    environment.interactiveShellInit = ''
      unset HISTFILE
      export GNUPGHOME=/run/user/$(id -u)/gnupg
      [ -d $GNUPGHOME ] || install -m 0700 -d $GNUPGHOME
      cp ${pkgs.drduh-gpg-conf}/gpg.conf $GNUPGHOME/gpg.conf
      cp ${gpg-agent-conf}  $GNUPGHOME/gpg-agent.conf
      echo "\$GNUPGHOME is $GNUPGHOME"
    '';
  }

  # Console.
  {
    fonts.packages = [ pkgs.roboto-mono ];
    services.kmscon = {
      enable = true;
      autologinUser = "nixos";
      hwRender = true;
      extraConfig = ''
        session-control
        palette=solarized
        font-name=Roboto Mono
        font-size=24
        xkb-layout=us
        xkb-options=ctrl:nocaps
        xkb-repeat-delay=500
        xkb-repeat-rate=33
      '';
    };
  }
]
