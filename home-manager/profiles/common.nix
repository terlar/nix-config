{ dotfiles, pkgs, ... }:

{
  imports = [ ./programs/bash.nix ./programs/fish.nix ./programs/git.nix ];

  systemd.user.startServices = "sd-switch";

  programs = {
    home-manager.enable = true;

    direnv = {
      enable = true;
      enableNixDirenvIntegration = true;
    };

    ssh = {
      enable = true;
      compression = true;
    };
  };

  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
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
