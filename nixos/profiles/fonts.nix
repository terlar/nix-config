{ pkgs, ... }:

let
  fonts = with pkgs; [
    iosevka-slab
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    noto-fonts-extra
  ];
in {
  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;

    inherit fonts;

    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [
          "Iosevka Slab"
          "Noto Sans Mono CJK SC"
          "Noto Emoji"
          "Noto Sans Symbols"
        ];
        sansSerif =
          [ "Noto Sans" "Noto Sans CJK SC" "Noto Emoji" "Noto Sans Symbols" ];
        serif =
          [ "Noto Serif" "Noto Sans CJK SC" "Noto Emoji" "Noto Sans Symbols" ];
      };
    };
  };
}
