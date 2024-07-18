{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.profiles.user.terje.graphical.fonts;
in
{
  options.profiles.user.terje.graphical.fonts = {
    enable = lib.mkEnableOption "fonts profile for Terje";
  };

  config = lib.mkIf cfg.enable {
    fonts.fontconfig.enable = true;

    home.packages = [
      (pkgs.iosevka-bin.override { variant = "Aile"; })
      (pkgs.iosevka-bin.override { variant = "Etoile"; })
      (pkgs.iosevka-bin.override { variant = "CurlySlab"; })

      pkgs.noto-fonts
      pkgs.noto-fonts-cjk
      pkgs.noto-fonts-emoji
      pkgs.noto-fonts-extra
    ];
  };
}
