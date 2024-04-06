{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.user.terje.fonts;
in
{
  options.profiles.user.terje.fonts = {
    enable = lib.mkEnableOption "Fonts profile for terje";
  };

  config = lib.mkIf cfg.enable {
    fonts.fontconfig.enable = true;

    home.packages = [
      pkgs.iosevka-slab
      pkgs.noto-fonts
      pkgs.noto-fonts-cjk
      pkgs.noto-fonts-emoji
      pkgs.noto-fonts-extra
    ];
  };
}
