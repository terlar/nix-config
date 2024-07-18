{ config, lib, ... }:

let
  cfg = config.profiles.user.terje.programs.glow;
in
{
  options.profiles.user.terje.programs.glow = {
    enable = lib.mkEnableOption "glow configuration for Terje";
  };

  config = lib.mkIf cfg.enable {
    programs.glow = {
      style = {
        document = {
          block_prefix = "\n";
          block_suffix = "\n";
          margin = 2;
        };

        block_quote = {
          indent = 1;
          indent_token = "┃ ";
        };
        list.level_indent = 2;
        heading = {
          block_suffix = "\n";
          bold = true;
        };
        h1.prefix = "# ";
        h2.prefix = "## ";
        h3.prefix = "### ";
        h4.prefix = "#### ";
        h5.prefix = "##### ";
        h6 = {
          prefix = "###### ";
          bold = false;
        };
        strikethrough.crossed_out = true;
        emph.italic = true;
        strong.bold = true;
        hr.format = "\n────────\n";
        item.block_prefix = "• ";
        enumeration.block_prefix = ". ";
        task = {
          ticked = "☑ ";
          unticked = "□ ";
        };
        link.underline = true;
        link_text.bold = true;
        image.underline = true;
        image_text.format = "Image: {{.text}} ?";
        code = {
          prefix = " ";
          suffix = " ";
        };
        code_block = {
          margin = 2;
          chroma = {
            keyword.bold = true;
            name_builtin.bold = true;
            name_class = {
              underline = true;
              bold = true;
            };
            generic_emph.italic = true;
            generic_strong.bold = true;
          };
        };
        table = {
          center_separator = "╂";
          column_separator = "┃";
          row_separator = "─";
        };
        definition_description = {
          block_prefix = "\n► ";
        };
      };
    };
  };
}
