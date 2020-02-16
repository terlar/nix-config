{ pkgs }:

with pkgs;

let
  aspellEnv = aspellWithDicts(ps: [ ps.en ps.sv ]);
  hunspellEnv = hunspellWithDicts(with hunspellDicts; [en-us sv-se]);
in [
  # nix
  cachix
  home-manager
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
  openssh
  traceroute
  wget

  # security
  lastpass-cli
  mkpasswd
  pass
  pwgen

  # utility
  aspellEnv
  browsh
  buku
  coreutils
  fd
  file
  fish
  fzy
  htop
  hunspellEnv
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
  xsv

  # file system
  nfs-utils
  cifs-utils
]
