{ dotfiles, pkgs, ... }:

{
  imports = [
    ./development/javascript.nix
    ./development/python.nix

    ./programs/bat.nix
    ./programs/ripgrep.nix
  ];

  home.file.".editorconfig".source = "${dotfiles}/editorconfig/.editorconfig";

  home.packages = with pkgs; [
    curlie
    editorconfig-core-c
    hey
    jq
    plantuml
    saw
    shellcheck
    termtosvg
  ];
}
