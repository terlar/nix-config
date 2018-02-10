{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs.elmPackages; [
    elm
    elm-compiler
    elm-format
    elm-make
    elm-package
    elm-reactor
    elm-repl
  ];
}
