{ config, lib, pkgs, ... }:

{
  programs.ssh.startAgent = false;

  programs.gnupg.agent =
    { enable = true;
      enableSSHSupport = true;
    };

  services.pcscd.enable = true;

  environment.systemPackages = with pkgs;
    [ gnupg
      yubikey-personalization
    ];

  services.udev.packages = with pkgs;
    [ yubikey-personalization
    ];
}