{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkDefault mkIf mkMerge;

  cfg = config.profiles.development;
in
{
  imports = [ ./interface.nix ];

  config = mkIf cfg.enable (mkMerge [
    {
      profiles = {
        direnv.enable = mkDefault true;
        git.enable = mkDefault true;
        gnupg.enable = mkDefault true;
      };

      editorconfig = {
        enable = mkDefault true;
        settings = {
          "*" = {
            charset = "utf-8";
            end_of_line = "lf";
            trim_trailing_whitespace = true;
            insert_final_newline = true;
          };
          "*.plantuml" = {
            indent_style = cfg.plantuml.indentStyle;
            indent_size = cfg.plantuml.indentSize;
          };
        };
      };

      home.packages = [
        pkgs.gron
        pkgs.hey
        pkgs.jaq
        pkgs.nodePackages.json-diff
        pkgs.xh
      ];
    }

    (mkIf cfg.javascript.enable {
      editorconfig.settings."*.{js,jsx,json,ts,tsx}" = {
        indent_style = cfg.javascript.indentStyle;
        indent_size = cfg.javascript.indentSize;
      };
    })

    (mkIf cfg.python.enable {
      home.file.".ipython/profile_default/ipython_config.py".text = ''
        c.InteractiveShellApp.extensions = ['autoreload']
        c.InteractiveShellApp.exec_lines = ['%autoreload 2']
      '';

      editorconfig.settings."*.py" = {
        indent_style = cfg.python.indentStyle;
        indent_size = cfg.python.indentSize;
      };
    })

    (mkIf cfg.nix.enable (mkMerge [
      {
        home.packages = [
          # Use
          pkgs.cachix
          pkgs.nix-index
          pkgs.nix-output-monitor

          # Develop
          pkgs.manix
          pkgs.nil
          pkgs.nix-init
          pkgs.nurl

          # Debug
          pkgs.nix-diff
          pkgs.nix-du
          pkgs.nix-tree
        ];
      }
    ]))

    (mkIf cfg.shell.enable {
      home.packages = [
        pkgs.shellcheck
        pkgs.shfmt
      ];

      editorconfig.settings."*.{bash,sh}" = {
        indent_style = cfg.shell.indentStyle;
        indent_size = cfg.shell.indentSize;
      };
    })
  ]);
}
