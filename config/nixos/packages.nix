{ pkgs }:

with pkgs;

[
  # nix
  cachix
  haskellPackages.nix-derivation
  home-manager
  nix-diff
  nix-index
  nix-prefetch-scripts
  nixStable

  # compression/archive
  p7zip
  unrar
  unzip
  zip

  # git
  git-lfs
  gitAndTools.ghq
  gitAndTools.git-crypt
  gitAndTools.git-imerge
  gitAndTools.gitFull
  gitAndTools.hub
  gitAndTools.tig

  # hardware tools
  hdparm
  lshw
  lsof
  pciutils

  # media
  playerctl
  surfraw
  youtube-dl

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
  browsh
  buku
  coreutils
  fd
  file
  fish
  fzy
  htop
  menu
  moreutils
  most
  pdfgrep
  procs
  ripgrep
  ripgrep-all
  texlive.combined.scheme-full
  tldr
  tree
  units
  unixtools.xxd
  xsv

  # file system
  nfs-utils
  cifs-utils
]
