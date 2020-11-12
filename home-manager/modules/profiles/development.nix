{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.profiles.development;

  mkIndentStyleOption = lang: default:
    mkOption {
      type = types.enum [ "space" "tab" ];
      inherit default;
      description = "Indentation style for ${lang}";
    };

  mkIndentSizeOption = lang: default:
    mkOption {
      type = types.int;
      inherit default;
      description = "Indentation size for ${lang}";
    };
in {
  options.profiles.development = {
    enable = mkEnableOption "Development profile";

    aws = { enable = mkEnableOption "AWS Development profile"; };

    javascript = {
      enable = mkEnableOption "JavaScript Development profile";

      ignoreScripts = mkOption {
        default = true;
        type = types.bool;
        description = ''
          Ignore scripts.

          This prevents modules to execute arbitrary scripts during installation. A
          inconvenient side-effect is that it also disables running scripts from
          package.json as well.
        '';
      };

      indentStyle = mkIndentStyleOption "JavaScript" "space";
      indentSize = mkIndentSizeOption "JavaScript" 2;
    };

    python = {
      enable = mkEnableOption "Python Development profile";
      indentStyle = mkIndentStyleOption "Python" "space";
      indentSize = mkIndentSizeOption "Python" 4;
    };

    shell = {
      enable = mkEnableOption "Shell Development profile";
      indentStyle = mkIndentStyleOption "Shell" "tab";
      indentSize = mkIndentSizeOption "Shell" 2;
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      home.packages = with pkgs; [ curlie hey jq plantuml ];

      programs.bat = {
        enable = true;
        config = {
          theme = "GitHub";
          pager = "less -FR";
        };
      };

      programs.editorConfig = {
        enable = true;
        settings."*" = {
          end_of_line = "lf";
          charset = "utf-8";
          trim_trailing_whitespace = true;
          insert_final_newline = true;
        };
      };

      programs.ripgrep = {
        enable = true;
        extraConfig = ''
          --max-columns=150
          --max-columns-preview

          --glob=!.git/*

          --smart-case
        '';
      };
    }

    (mkIf cfg.aws.enable { home.packages = with pkgs; [ awscli saw ]; })

    (mkIf cfg.javascript.enable {
      home.packages = with pkgs; [
        nodePackages.jsonlint
        nodePackages.prettier
      ];

      home.file.".npmrc".text = ''
        ${optionalString cfg.javascript.ignoreScripts ''
          ignore-scripts=true
        ''}
      '';

      home.file.".yarnrc".text = ''
        disable-self-update-check true
        ${optionalString cfg.javascript.ignoreScripts ''
          ignore-scripts true
        ''}
      '';

      programs.editorConfig.settings."*.{js,jsx,json,ts,tsx}" = {
        indent_style = cfg.javascript.indentStyle;
        indent_size = cfg.javascript.indentSize;
      };
    })

    (mkIf cfg.python.enable {
      home.file.".ipython/profile_default/ipython_config.py".text = ''
        c.InteractiveShellApp.extensions = ['autoreload']
        c.InteractiveShellApp.exec_lines = ['%autoreload 2']
      '';

      programs.editorConfig.settings."*.py" = {
        indent_style = cfg.python.indentStyle;
        indent_size = cfg.python.indentSize;
      };
    })

    (mkIf cfg.shell.enable {
      home.packages = with pkgs; [ shellcheck termtosvg ];

      programs.editorConfig.settings."*.{bash,sh}" = {
        indent_style = cfg.shell.indentStyle;
        indent_size = cfg.shell.indentSize;
      };
    })
  ]);
}
