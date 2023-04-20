{pkgs, ...}: let
  drduh-gpg-conf = pkgs.callPackage ./drduh-gpg-conf.nix {};
  drduh-yubikey-guide = pkgs.callPackage ./drduh-yubikey-guide.nix {};
  gpg-agent-conf = pkgs.writeText "gpg-agent.conf" ''
    pinentry-program ${pkgs.pinentry-curses}/bin/pinentry-curses
  '';
in {
  # Required packages and services.
  services.pcscd.enable = true;
  services.udev.packages = [pkgs.yubikey-personalization];
  environment.systemPackages = [
    pkgs.gnupg
    pkgs.pinentry-curses
    pkgs.paperkey
    pkgs.wget

    # Disable due to broken dependencies.
    # pkgs.haskellPackages.hopenpgp-tools
    pkgs.yubikey-manager

    drduh-yubikey-guide
  ];

  programs = {
    ssh.startAgent = false;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  # Avoid accidental persistence to USB-drive
  boot.kernelParams = ["copytoram"];

  # Disable networking
  boot.initrd.network.enable = false;
  networking.dhcpcd.enable = false;
  networking.dhcpcd.allowInterfaces = [];
  networking.firewall.enable = true;
  networking.useDHCP = false;
  networking.useNetworkd = false;
  networking.wireless.enable = false;

  # Secure defaults.
  boot.tmp.cleanOnBoot = true;
  boot.kernel.sysctl = {
    "kernel.unprivileged_bpf_disabled" = 1;
  };

  # Set up the shell for making keys.
  environment.interactiveShellInit = ''
    unset HISTFILE
    export GNUPGHOME=/run/user/$(id -u)/gnupg
    [ -d $GNUPGHOME ] || install -m 0700 -d $GNUPGHOME
    cp ${drduh-gpg-conf}/gpg.conf $GNUPGHOME/gpg.conf
    cp ${gpg-agent-conf}  $GNUPGHOME/gpg-agent.conf
    echo "\$GNUPGHOME is $GNUPGHOME"
  '';

  # Console.
  fonts.fonts = [pkgs.roboto-mono];
  services.kmscon = {
    enable = true;
    autologinUser = "nixos";
    hwRender = true;
    extraConfig = ''
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
