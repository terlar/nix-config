{pkgs, ...}: {
  fonts = {
    fonts = with pkgs; [
      iosevka-slab
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      noto-fonts-extra
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = ["Iosevka Slab" "Noto Sans Mono CJK SC" "Noto Sans Symbols"];
        sansSerif = ["Noto Sans" "Noto Sans CJK SC" "Noto Sans Symbols"];
        serif = ["Noto Serif" "Noto Sans CJK SC" "Noto Sans Symbols"];
      };
    };
  };
}
