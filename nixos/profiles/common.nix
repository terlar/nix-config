{ pkgs, ... }:

{
  imports = [ ./console.nix ./programs/gnupg.nix ./hardware/yubikey.nix ];

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  programs.command-not-found.enable = true;

  # Enable super user handling.
  security.sudo.enable = true;

  services = {
    # Auto-mount disks.
    udisks2.enable = true;
  };

  environment.systemPackages = with pkgs; [
    # nix
    cachix
    manix
    nix-diff
    nix-du
    nix-index
    nix-prefetch-scripts
    nix-tree
    rnix-lsp

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
    rclone
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
    graphviz
    moreutils
    most
    procs
    tree
    unixtools.xxd
    xsv

    # file system
    cifs-utils
    httpfs
    nfs-utils
  ];
}
