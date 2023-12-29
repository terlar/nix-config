{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.profiles.user.terje.base;

  jsonFormat = pkgs.formats.json {};
  yamlFormat = pkgs.formats.yaml {};
in {
  options.profiles.user.terje.base = {
    enable = lib.mkEnableOption "Base profile for terje";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      home.stateVersion = "20.09";

      programs.home-manager.enable = true;
      systemd.user.startServices = "sd-switch";
      manual.html.enable = true;

      xdg.enable = true;
      xdg.mimeApps.enable = true;

      profiles = {
        user.terje.shell.enable = lib.mkDefault true;
        user.terje.keyboards.enable = lib.mkDefault true;

        gnupg.enable = lib.mkDefault true;
        development = {
          enable = lib.mkDefault true;
          javascript.enable = lib.mkDefault true;
          python.enable = lib.mkDefault true;
          nix.enable = lib.mkDefault true;
          shell.enable = lib.mkDefault true;
        };
      };

      home.sessionVariables.LS_COLORS = "";

      custom = {
        keyboard = {
          enable = true;
          layouts = [{layout = "us";} {layout = "se";}];
          xkbOptions = ["ctrl:nocaps"];
          repeatDelay = 500;
          repeatInterval = 33; # 30Hz
        };

        keybindings = {
          enable = true;
          mode = "emacs";
        };

        emacsConfig = {
          enable = true;
          defaultEmailApplication = true;
          defaultPdfApplication = true;
        };
      };
    }

    {
      programs = {
        bat.config = {
          theme = "GitHub";
          pager = "less -FR";
        };

        readline.enable = true;

        ssh = {
          enable = true;
          compression = true;
        };
      };
    }

    # Git
    {
      programs.git = {
        ignores = [".dir-locals.el" ".direnv/" ".envrc"];

        extraConfig = {
          ghq = {
            "git@code.orgmode.org:" = {vcs = "git";};
            "https://git.savannah.gnu.org/git/" = {vcs = "git";};
          };

          delta = {
            features = "decorations";

            syntax-theme = "none";
            zero-style = "grey";
            minus-emph-style = "strike bold";
            minus-style = "strike";
            plus-emph-style = "bold italic";
            plus-style = "bold";
            line-numbers-minus-style = "red";
            line-numbers-plus-style = "bold";
          };

          url = {
            "ssh://git@github.com/terlar" = {insteadOf = "gh:terlar";};
            "https://github.com/" = {insteadOf = "gh:";};
          };
        };
      };
    }

    # Nix
    {
      home.packages = [
        pkgs.nix-your-shell
      ];

      nix = {
        package = lib.mkDefault pkgs.nixVersions.stable;
        settings = {
          # Build
          max-jobs = "auto";
          http-connections = 50;

          # Store
          auto-optimise-store = true;
          min-free = 1024;
        };
        extraOptions = builtins.readFile ../../../../../nix.conf;
      };

      programs.fish.interactiveShellInit = ''
        nix-your-shell fish | source
      '';
    }

    # Glow
    {
      xdg.configFile."glow/glow.yml".source = let
        styleFile = jsonFormat.generate "custom.json" {
          document = {
            block_prefix = "\n";
            block_suffix = "\n";
            margin = 2;
          };

          block_quote = {
            color = "0";
            indent = 1;
            indent_token = "┃ ";
          };
          list = {
            color = "0";
            level_indent = 2;
          };
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
          link = {
            color = "#007ec4";
            underline = true;
          };
          link_text = {
            color = "#007ec4";
            bold = true;
          };
          image = {
            color = "#007ec4";
            underline = true;
          };
          image_text = {
            format = "Image: {{.text}} ?";
          };
          code = {
            prefix = " ";
            suffix = " ";
            background_color = "11";
          };
          code_block = {
            margin = 2;
            chroma = {
              text.background_color = "#f4eedb";
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
            color = "0";
            center_separator = "╂";
            column_separator = "┃";
            row_separator = "─";
          };
          definition_description = {
            block_prefix = "\n► ";
          };
        };
      in
        yamlFormat.generate "glow.yml" {
          style = styleFile;
          pager = true;
        };
    }

    # Packages
    {
      home.packages = with pkgs; [
        themepark

        # media
        playerctl
        surfraw
        youtube-dl

        # utility
        browsh
        fzy
        pdfgrep
        pywal
        tldr
        units
        xsv
      ];
    }
  ]);
}
