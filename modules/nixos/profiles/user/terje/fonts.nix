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
        pkgs.iosevka-slab
        pkgs.noto-fonts
        pkgs.noto-fonts-cjk
        pkgs.noto-fonts-emoji
        pkgs.noto-fonts-extra
      ];

      fontconfig = {
        enable = lib.mkDefault true;
        defaultFonts = {
          monospace = [
            "Iosevka Slab"
            "Noto Sans Mono CJK SC"
            "Noto Sans Symbols"
          ];
          sansSerif = [
            "Noto Sans"
            "Noto Sans CJK SC"
            "Noto Sans Symbols"
          ];
          serif = [
            "Noto Serif"
            "Noto Sans CJK SC"
            "Noto Sans Symbols"
          ];
        };
      };
    };
  };
}
