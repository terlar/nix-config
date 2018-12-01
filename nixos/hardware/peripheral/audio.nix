{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ponymix
  ];

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    extraConfig = ''
      load-module module-switch-on-connect
    '';
  };
}
