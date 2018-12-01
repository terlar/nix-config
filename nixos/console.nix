{ config, pkgs, ... }:

{
  imports = [
    ./fonts.nix
  ];

  services.kmscon = {
    enable = true;
    hwRender = true;
    extraConfig = ''
      palette=solarized-white
      font-name=Fira Mono
      font-size=20
    '';
  };
}
