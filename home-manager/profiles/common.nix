{ dotfiles, pkgs, ... }:

{
  imports = [ ./programs/bash.nix ./programs/fish.nix ./programs/git.nix ];

  services.lorri.enable = true;

  programs = {
    home-manager.enable = true;

    direnv.enable = true;

    gpg.enable = true;
    ssh = {
      enable = true;
      compression = true;
    };
  };

  xdg.enable = true;
  xdg.mimeApps.enable = true;

  manual.html.enable = true;

  home.packages = with pkgs; [
    scripts.insomnia
    scripts.themepark

    # media
    playerctl
    surfraw
    youtube-dl

    # utility
    browsh
    fzy
    htop
    menu
    pdfgrep
    pywal
    tldr
    units
    xsv
  ];
}
