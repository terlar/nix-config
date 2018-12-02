{ pkgs }:

with pkgs;

let
  emacsPackages     = import ./emacs.nix pkgs;
  emacsWithPackages = pkgs.emacsHEADPackagesNg.emacsWithPackages;
  emacsEnv          = emacsWithPackages emacsPackages;
in ([
  nixStable
  home-manager
  coreutils
  moreutils
  fish
  openssh
  emacsEnv

  # git tools
  git-lfs
  gitAndTools.ghq
  gitAndTools.git-crypt
  gitAndTools.git-imerge
  gitAndTools.gitFull
  gitAndTools.hub
  gitAndTools.tig

  # system tools
  aspell
  aspellDicts.en
  aspellDicts.sv
  curl
  direnv
  fd
  file
  fzy
  gnumake
  gnupg
  htop
  most
  p7zip
  pinentry
  pwgen
  ripgrep
  tldr
  tree
  units
  unrar
  unzip
  wget
  xsv
  zip

  # dev tools
  bat
  editorconfig-core-c
  httpie
  jq
] ++ lib.optionals stdenv.isLinux [
  rofi
  xclip

  # dev tools
  docker
  docker_compose
  sysdig

  # media tools
  playerctl
  surfraw
  youtube-dl
] ++ lib.optionals stdenv.isDarwin [
  skhd

  # Applications
  docker
])
