{ pkgs }:

with pkgs;

let
  aspellEnv = aspellWithDicts(ps: [ ps.en ps.sv ]);
  sysconfig = (import <nixpkgs/nixos> {}).config;
in ([
  nixStable
  nix-prefetch-scripts
  home-manager
  coreutils
  dnsutils
  moreutils
  fish
  openssh

  # git tools
  git-lfs
  gitAndTools.ghq
  gitAndTools.git-crypt
  gitAndTools.git-imerge
  gitAndTools.gitFull
  gitAndTools.hub
  gitAndTools.tig

  # system tools
  aspellEnv
  browsh
  buku
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
  pdfgrep
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
  cabal2nix
  stack2nix
] ++ lib.optionals stdenv.isLinux [
  # system tools
  hdparm
  lshw
  lsof

  # dev tools
  docker
  docker-slim
  docker_compose
  shellcheck
  sysdig

  # media tools
  playerctl
  surfraw
  youtube-dl

  # security tools
  lastpass-cli
  mkpasswd
  pass
] ++ lib.optionals sysconfig.services.xserver.enable [
  scripts.emacseditor
  scripts.lock
  scripts.logout
  scripts.window_tiler

  chromium
  feh
  firefox
  imagemagick
  kitty
  krita
  maim
  mpv
  qutebrowser
  rofi
  slack
  slop
  spotify
  sxiv
  xautolock
  xclip
  xorg.xhost
  xsel
  xss-lock

  cifs-utils
  nfs-utils

  blueman
  gnome3.gcr
  gnome3.gnome-keyring
  gnome3.seahorse
  libgnome-keyring
  libnotify
  networkmanagerapplet
  pavucontrol
  xfce.xfce4-notifyd

  gnome2.gtk
  gnome3.gtk
  gnome-themes-extra
  paper-gtk-theme
  paper-icon-theme
] ++ lib.optionals stdenv.isDarwin [
  skhd

  # Applications
  docker
])
