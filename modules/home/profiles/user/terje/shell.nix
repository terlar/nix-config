{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.user.terje.shell;
in
{
  options.profiles.user.terje.shell = {
    enable = lib.mkEnableOption "Shell profile for terje";
  };

  config = lib.mkIf cfg.enable {
    profiles = {
      shell = {
        enable = true;
        fish = {
          enableBaseConfig = true;
          enablePackageCompletionPlugins = true;
        };
      };
    };

    programs = {
      bat.config = {
        theme = "GitHub";
        pager = "less -FR";
      };

      glow = {
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

      password-store = {
        enable = true;
        package = pkgs.pass.withExtensions (ext: [
          ext.pass-import
          ext.pass-genphrase
          ext.pass-update
          ext.pass-otp
        ]);
      };
    };

    home.packages = [
      pkgs.fzy
      pkgs.pdfgrep
      pkgs.tldr
      pkgs.units
      pkgs.unzip
      pkgs.xsv
    ];
  };
}
