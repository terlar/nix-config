{ pkgs, ... }:

{
  environment = {
    shells = [ pkgs.fish ];
    variables.SHELL = "${pkgs.fish}/bin/fish";
  };

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
}
