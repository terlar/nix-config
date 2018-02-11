{ config, pkgs, ... }:

{
  imports = [
    ./console.nix
  ];

  nixpkgs.config.allowUnfree = true;
  security.sudo.enable = true;

  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
  };

  environment.systemPackages = with pkgs; [
    nix-repl
    mkpasswd pwgen
    gitFull git-lfs gitAndTools.hub gitAndTools.ghq
    zip unzip unrar p7zip
    curl wget
    file tree
    gnumake stow
    most
    ripgrep
    units tldr
    fd fzf fzy
    jq
    w3m
    dropbox-cli lastpass-cli
    surfraw
    youtube-dl
  ];

  networking.useNetworkd = true;

  services = {
    ntp.enable = true;
    dnsmasq = {
      enable = true;
      servers = [ "127.0.0.1#43" ];
    };
  };
}
