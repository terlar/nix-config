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

      nushell = {
        environmentVariables.LS_COLORS = "";
        settings.color_config = {
          binary = "default";
          block = "default";
          bool = "default";
          cell-path = "default";
          closure = "default";
          datetime = "default";
          duration = "default";
          empty = "default";
          filesize = "default";
          float = "default";
          glob = "default";
          header = "default";
          hints = "dark_gray";
          int = "default";
          list = "default";
          nothing = "default";
          range = "default";
          record = "default";
          row_index = "default";
          # search_result = "default";
          shape_binary = "default";
          shape_block = "default";
          shape_bool = "default";
          shape_closure = "default";
          shape_custom = "default";
          shape_datetime = "default";
          shape_directory = "default";
          shape_external = "red";
          shape_external_resolved = "default_bold";
          shape_externalarg = "default";
          shape_filepath = "default";
          shape_flag = "default";
          shape_float = "default";
          shape_glob_interpolation = "default";
          shape_globpattern = "default";
          shape_int = "default";
          shape_internalcall = "default_bold";
          shape_keyword = "default";
          shape_list = "default";
          shape_literal = "default";
          shape_match_pattern = "default";
          shape_nothing = "default";
          shape_operator = "default";
          shape_pipe = "default";
          shape_range = "default";
          shape_raw_string = "default";
          shape_record = "default";
          shape_redirection = "default";
          shape_signature = "default";
          shape_string = "default";
          shape_string_interpolation = "default";
          shape_table = "default";
          shape_vardecl = "default";
          shape_variable = "default";
          string = "default";
        };
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
