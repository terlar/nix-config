{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ google-chrome-beta-with-pipewire ];
}
