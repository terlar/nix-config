{ pkgs, ... }:

{
  programs.light.enable = true;
  environment.systemPackages = [ pkgs.light ];
}
