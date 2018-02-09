{ config, pkgs, ... }:

{
  hardware.pulseaudio.package = pkgs.pulseaudioFull;

  hardware.bluetooth = {
    enable = true;
    extraConfig = ''
      [general]
      Enable=Source,Sink,Media,Socket
    '';
  };
}
