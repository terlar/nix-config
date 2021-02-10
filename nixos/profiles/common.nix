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

    # Limit storage space of journald.
    journald.extraConfig = ''
      SystemMaxUse=100M
      RuntimeMaxUse=100M
    '';
  };

  custom = {
    dictionaries = {
      enable = true;
      languages = [ "en-us" "sv-se" ];
    };

    keyboard = {
      enable = true;
      xkbOptions = "ctrl:nocaps";
      xkbRepeatDelay = 500;
      xkbRepeatInterval = 33; # 30Hz
    };

    i18n = {
      enable = true;
      languages = [ "chinese" ];
    };

    shell = {
      enable = true;
      package = pkgs.fish;
    };
  };

  time.timeZone = "Europe/Stockholm";
  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
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
    file
    graphviz
    moreutils
    most
    procs
    unixtools.xxd
    xsv

    # file system
    cifs-utils
    httpfs
    nfs-utils
  ];
}
