{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ghc
    stack
  ];
}
