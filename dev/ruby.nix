{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ruby_2_5
    bundler
  ];
}
