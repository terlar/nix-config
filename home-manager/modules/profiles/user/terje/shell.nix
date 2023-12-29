{
  config,
  dotfiles,
  lib,
  pkgs,
  ...
}: let
  cfg = config.profiles.user.terje.shell;

  sourceDirFiles = attrRoot: destination: target: {
    ${attrRoot} = lib.pipe target [
      builtins.readDir
      builtins.attrNames
      (builtins.foldl'
        (attrs: file: attrs // {"${destination}/${file}".source = "${toString target}/${file}";})
        {})
    ];
  };

  packageWithMainProgram = mainProgram: pkg:
    (pkg.meta.mainProgram or "") == mainProgram;

  anyPackageWithMainProgram = mainProgram:
    builtins.any (packageWithMainProgram mainProgram) config.home.packages;

  plugins =
    lib.optional (anyPackageWithMainProgram "aws") {
      name = "aws";
      src = pkgs.fetchFromGitHub {
        owner = "terlar";
        repo = "plugin-aws";
        rev = "142c68b2828de93730d00b2b0421242df128e8fc";
        sha256 = "1cgyhjdh29jfly875ly31cjsymi45b3qipydsd9mvb1ws0r6337c";
        # date = 2020-04-22T09:47:07+02:00;
      };
    }
    ++ lib.optional (anyPackageWithMainProgram "kubectl") {
      name = "kubectl-completions";
      src = pkgs.fetchFromGitHub {
        owner = "evanlucas";
        repo = "fish-kubectl-completions";
        rev = "bbe3b831bcf8c0511fceb0607e4e7511c73e8c71";
        sha256 = "1r6wqvvvb755jkmlng1i085s7cj1psxmddqghm80x5573rkklfps";
        # date = 2021-01-21T11:57:06-06:00;
      };
    }
    ++ lib.optional (anyPackageWithMainProgram "gcloud") {
      name = "google-cloud-sdk-completions";
      src = pkgs.fetchFromGitHub {
        owner = "lgathy";
        repo = "google-cloud-sdk-fish-completion";
        rev = "bc24b0bf7da2addca377d89feece4487ca0b1e9c";
        sha256 = "03zzggi64fhk0yx705h8nbg3a02zch9y49cdvzgnmpi321vz71h4";
        # date = "2016-11-05T11:35:26+01:00";
      };
    };
in {
  options.profiles.user.terje.shell = {
    enable = lib.mkEnableOption "Shell profile for terje";
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = [pkgs.bashInteractive];

      sessionVariables.LS_COLORS = "";
    };

    programs = {
      bash.enable = true;
      fish = {
        enable = true;
        inherit plugins;
      };

      glow = {
        enable = true;
        settings.pager = true;
        style = {
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
      };
    };

    xdg = lib.mkMerge [
      (sourceDirFiles "configFile" "fish/completions"
        "${dotfiles}/fish/.config/fish/completions")
      (sourceDirFiles "configFile" "fish/conf.d"
        "${dotfiles}/fish/.config/fish/conf.d")
      (sourceDirFiles "configFile" "fish/functions"
        "${dotfiles}/fish/.config/fish/functions")
    ];
  };
}
