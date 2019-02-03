{ config, pkgs, lib, ... }:

{
  programs = {
    rofi = {
      enable = true;
      font = "monospace 16";
      separator = "solid";
      colors =
        let
          bg = "#273238";
          bgAlt = "#1e2529";
          bgHigh = "#394249";
          fg = "#c1c1c1";
          fgHigh = "#ffffff";
          fgActive = "#80cbc4";
          fgUrgent = "#ff1844";
        in {
          window = {
            background = bg;
            border = bg;
            separator = bgAlt;
          };

          rows = {
            normal = {
              foreground = fg;
              background = bg;
              backgroundAlt = bg;
              highlight = {
                foreground = fgHigh;
                background = bgHigh;
              };
            };
            active = {
              foreground = fgActive;
              background = bg;
              backgroundAlt = bg;
              highlight = {
                foreground = fgActive;
                background = bgHigh;
              };
            };
            urgent = {
              foreground = fgUrgent;
              background = bg;
              backgroundAlt = bg;
              highlight = {
                foreground = fgUrgent;
                background = bgHigh;
              };
            };
          };
        };
    };
  };
}
