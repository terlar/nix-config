{ config, lib, ... }:

let
  cfg = config.profiles.monochrome;
in
{
  options.profiles.monochrome = {
    enable = lib.mkEnableOption "monochrome profile";
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables.LS_COLORS = "";

    programs = {
      bat.config.theme = "GitHub";

      foot.settings.colors = {
        foreground = "002b37";
        background = "fffce9";
        regular0 = "002b37"; # black
        regular1 = "bb3e06"; # red
        regular2 = "596e76"; # green
        regular3 = "98a6a6"; # yellow
        regular4 = "596e76"; # blue
        regular5 = "596e76"; # magenta
        regular6 = "596e76"; # cyan
        regular7 = "98a6a6"; # white
        bright0 = "596e76"; # bright black
        bright1 = "cc1f24"; # bright red
        bright2 = "002b37"; # bright green
        bright3 = "f4eedb"; # bright yellow
        bright4 = "002b37"; # bright blue
        bright5 = "002b37"; # bright magenta
        bright6 = "002b37"; # bright cyan
        bright7 = "f4eedb"; # bright white
      };

      git.delta.options = {
        syntax-theme = "none";
        zero-style = "grey";
        minus-emph-style = "strike bold";
        minus-style = "strike";
        plus-emph-style = "bold italic";
        plus-style = "bold";
        line-numbers-minus-style = "red";
        line-numbers-plus-style = "bold";
      };

      glow.style = {
        block_quote.color = "0";
        list.color = "0";
        link.color = "#007ec4";
        link_text.color = "#007ec4";
        image.color = "#007ec4";
        code.background_color = "11";
        code_block.chroma.text.background_color = "#f4eedb";
        table.color = "0";
      };
    };
  };
}
