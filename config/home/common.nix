{ lib, ... }:

{
  imports = [
    ../../config/home/fish
    ../../config/home/git.nix
  ];

  # Configuration for nixpkgs within `home-manager` evaluation.
  nixpkgs.config = import ../nixpkgs.nix;
  # Configuration for nixpkgs outside `home-manager`, such as `nix-env`.
  xdg.configFile."nixpkgs/config.nix".source = ../nixpkgs.nix;

  services.lorri.enable = true;

  home.file.".editorconfig".source = <dotfiles/editorconfig/.editorconfig>;

  programs = {
    home-manager = {
      enable = true;
      path = toString <home-manager>;
    };

    direnv.enable = true;
    gpg.enable = true;

    ssh = {
      enable = true;
      compression = true;
    };
  };

  xdg.enable = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/mailto" = "emacsmail.desktop";
      "application/pdf" = "emacsclient.desktop";
    };
  };

  manual.html.enable = true;
}
