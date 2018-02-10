{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    rustup
    rustfmt
    rustracer
    rustPlatform.rustcSrc
  ];
}
