{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.programs.editorConfig;
  toINI = generators.toINI { };
in
{
  options.programs.editorConfig = {
    enable = mkEnableOption "EditorConfig";
    settings = mkOption {
      type = with types; attrsOf (attrsOf (oneOf [ bool float int str ]));
      default = { };
      description = ''
        Options to add to <filename>.editorconfig</filename> file.
        See
        <citerefentry>
          <refentrytitle>editorconfig-format</refentrytitle>
          <manvolnum>5</manvolnum>
        </citerefentry>
        for options.
      '';
      example = literalExample ''
        {
          "*" = {
            end_of_line = "lf";
            charset = "utf-8";
            trim_trailing_whitespace = true;
            insert_final_newline = true;
          };
          "*.{yaml,yml}" = {
            indent_style = "space";
            indent_size = 2;
          };
        }
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.editorconfig-core-c ];
    home.file.".editorconfig".text = ''
      root = true

      ${toINI cfg.settings}
    '';
  };
}
