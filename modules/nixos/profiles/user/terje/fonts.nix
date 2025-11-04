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
    fonts = {
      packages = [
        (pkgs.iosevka-bin.override { variant = "Aile"; })
        (pkgs.iosevka-bin.override { variant = "Etoile"; })
        (pkgs.iosevka-bin.override { variant = "CurlySlab"; })
        pkgs.noto-fonts
        pkgs.noto-fonts-cjk-sans
        pkgs.noto-fonts-color-emoji
      ];

      fontconfig = {
        enable = lib.mkDefault true;
        defaultFonts = {
          monospace = [
            "Iosevka Curly Slab"
            "Noto Sans Mono CJK SC"
            "Noto Sans Symbols"
          ];
          sansSerif = [
            "Iosevka Aile"
            "Noto Sans"
            "Noto Sans CJK SC"
            "Noto Sans Symbols"
          ];
          serif = [
            "Iosevka Etoile"
            "Noto Serif"
            "Noto Sans CJK SC"
            "Noto Sans Symbols"
          ];
        };
      };
    };
  };
}
