{ pkgs }:

with pkgs;

let
  aspellEnv = aspellWithDicts(ps: [ ps.en ps.sv ]);
  hunspellEnv = hunspellWithDicts(with hunspellDicts; [en-us sv-se]);
  sysconfig = (import <nixpkgs/nixos> {}).config;
in ([
  cachix
  home-manager
  nix-prefetch-scripts
  nixStable

  # compression/archive tools
  p7zip
  unrar
  unzip
  zip

  # dev tools
  bat
  cabal2nix
  editorconfig-core-c
  gnumake
  hey
  httpie
  jq
  nodePackages.jsonlint
  nodePackages.prettier
  plantuml
  saw
  shellcheck
  termtosvg

  # git tools
  git-lfs
  gitAndTools.ghq
  gitAndTools.git-crypt
  gitAndTools.git-imerge
  gitAndTools.gitFull
  gitAndTools.hub
  gitAndTools.tig

  # network tools
  curl
  dnsutils
  openssh
  wget

  # security tools
  lastpass-cli
  mkpasswd
  pass
  pwgen

  # utility tools
  aspellEnv
  browsh
  buku
  coreutils
  direnv
  fd
  file
  fish
  fzy
  htop
  hunspellEnv
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

  # samba
  nfs-utils
  cifs-utils
] ++ lib.optionals stdenv.isLinux [
  menu

  # dev tools
  docker
  docker-slim
  docker_compose
  sysdig

  # hardware tools
  hdparm
  lshw
  lsof
  pciutils

  # media tools
  playerctl
  surfraw
  youtube-dl

  # network tools
  traceroute
] ++ lib.optionals sysconfig.services.xserver.enable [
  scripts.emacseditor
  scripts.emacsmail
  scripts.insomnia
  scripts.lock
  scripts.logout
  scripts.themepark
  scripts.window_tiler

  # appearance
  gnome2.gtk
  gnome3.gtk
  gnome-themes-extra
  paper-gtk-theme
  paper-icon-theme

  # applications
  firefox
  kitty
  krita
  luakit
  mpv
  qutebrowser
  slack
  spotify
  sxiv

  # desktop
  gnome3.gcr
  gnome3.gnome-keyring
  gnome3.seahorse
  libgnome-keyring
  libnotify
  networkmanagerapplet
  pavucontrol
  xfce.xfce4-notifyd

  # utility
  feh
  imagemagick
  maim
  rofi
  slop
  xautolock
  xcalib
  xclip
  xorg.xhost
  xsel
  xss-lock
])
