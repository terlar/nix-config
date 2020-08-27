{ pkgs, ... }:

{
  home.packages = [ pkgs.bashInteractive ];
  programs.bash.enable = true;
}
