{ ... }:

{
  # Virtual terminal.
  services.kmscon = {
    enable = true;
    hwRender = true;
    extraConfig = ''
      palette=solarized-white
      font-name=Iosevka Slab
      font-size=16
    '';
  };
}
