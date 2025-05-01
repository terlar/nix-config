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
        foreground = "000011";
        background = "fbf7ef";
        regular0 = "000011"; # black
        regular1 = "d6000c"; # red
        regular2 = "474747"; # green
        regular3 = "aaa69f"; # yellow
        regular4 = "474747"; # blue
        regular5 = "474747"; # magenta
        regular6 = "474747"; # cyan
        regular7 = "aaa69f"; # white
        bright0 = "474747"; # bright black
        bright1 = "d6000c"; # bright red
        bright2 = "474747"; # bright green
        bright3 = "474747"; # bright yellow
        bright4 = "000011"; # bright blue
        bright5 = "000011"; # bright magenta
        bright6 = "000011"; # bright cyan
        bright7 = "474747"; # bright white
      };

      nushell.extraEnv = ''
        $env.LS_COLORS = ""
      '';

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
        link.color = "0";
        link_text.color = "0";
        image.color = "0";
        code.background_color = "11";
        code_block.chroma.text.background_color = "#f1e9d2";
        table.color = "0";
      };
    };
  };
}
