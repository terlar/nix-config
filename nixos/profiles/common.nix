{ pkgs, ... }:

{
  imports =
    [ ../caches.nix ./console.nix ./programs/gnupg.nix ./hardware/yubikey.nix ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  programs.command-not-found.enable = true;

  # Enable super user handling.
  security.sudo.enable = true;

  services = {
    # Time management.
    ntp.enable = true;

    # Auto-mount disks.
    udisks2.enable = true;
  };

  environment.systemPackages = with pkgs; [
    # nix
    cachix
    haskellPackages.nix-derivation
    nix-diff
    nix-index
    nix-prefetch-scripts

    # compression/archive
    unrar
    unzip
    zip

    # hardware tools
    hdparm
    lshw
    lsof
    pciutils

    # network
    curl
    dnsutils
    ipcalc
    openssh
    traceroute
    wget

    # security
    lastpass-cli
    mkpasswd
    pass
    pwgen

    # utility
    coreutils
    fd
    file
    moreutils
    most
    procs
    tree
    unixtools.xxd
    xsv

    # file system
    nfs-utils
    cifs-utils
  ];
}
