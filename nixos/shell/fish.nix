{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    fish
  ];

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
}
