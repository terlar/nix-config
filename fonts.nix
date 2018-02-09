{ config, pkgs, ... }:

{
  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;

    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "Fira Mono" ];
        sansSerif = [ "Noto Sans" ];
        serif     = [ "Noto Serif" ];
      };
    };

    fonts = with pkgs; [
      unifont
      symbola
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      fira
      fira-mono
      fira-code
      fantasque-sans-mono
      emojione
      emacs-all-the-icons-fonts
      source-han-sans-simplified-chinese
      source-han-sans-traditional-chinese
    ];
  };
}
