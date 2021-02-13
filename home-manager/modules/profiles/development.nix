{ config, lib, pkgs, ... }:

with builtins;
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

    sourceDirectory = mkOption {
      type = with types; either path str;
      default = "${config.home.homeDirectory}/src";
      defaultText = "$HOME/src";
      apply = toString; # Prevent copies to Nix store.
      description = "The directory where source code is stored.";
    };

    git = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to enable Git Development profile";
      };

      enableDelta = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to use <command>delta</command> for diff outputs.
          See <link xlink:href="https://github.com/dandavison/delta"/>.
        '';
      };

      enableGhq = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to use <command>ghq</command> for remote repository management.
          See <link xlink:href="https://github.com/x-motemen/ghq"/>.
        '';
      };

      gitHub = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "Whether to enable GitHub Development profile";
        };

        reuseSshConnection = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Whether to reuse the GitHub SSH connection.

            Make git actions significantly faster by using the <command>ssh</command> option
            ControlMaster and ControlPath.
          '';
        };
      };
    };

    javascript = {
      enable = mkEnableOption "JavaScript Development profile";

      ignoreScripts = mkOption {
        type = types.bool;
        default = true;
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

    nix = { enable = mkEnableOption "Nix Development profile"; };

    plantuml = {
      indentStyle = mkIndentStyleOption "PlantUML" "space";
      indentSize = mkIndentSizeOption "PlantUML" 2;
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
      home.packages = with pkgs; [
        curlie
        fd
        gron
        hey
        jq
        nodePackages.json-diff
        plantuml
        tree
      ];

      programs.bat.enable = true;

      programs.direnv = {
        enable = true;
        enableNixDirenvIntegration = true;
      };

      programs.editorConfig = {
        enable = true;
        settings = {
          "*" = {
            end_of_line = "lf";
            charset = "utf-8";
            trim_trailing_whitespace = true;
            insert_final_newline = true;
          };
          "*.plantuml" = {
            indent_style = cfg.plantuml.indentStyle;
            indent_size = cfg.plantuml.indentSize;
          };
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

    (mkIf cfg.git.enable (mkMerge [
      {
        home.packages = with pkgs; [ git-imerge ];

        programs.git = {
          enable = true;
          package = pkgs.gitFull;

          aliases = {
            unstage = "reset HEAD";
            uncommit = "reset --soft HEAD^";
            unpush = "push --force-with-lease origin HEAD^:master";
            recommit = "commit --amend";
            ignore = "update-index --assume-unchanged";
            unignore = "update-index --no-assume-unchanged";
            ignored = "!git ls-files -v | grep '^[[:lower:]]'";

            fup =
              "!git log --stat --since '1 day ago' --author $(git config user.email)";
            tags = "tag -l";
            remotes = "remote -v";
            branches = concatStringsSep " " [
              "!git"
              "for-each-ref"
              "--sort=-committerdate"
              "--format='${
                concatStringsSep "|" [
                  "%(color:blue)%(authordate:relative)"
                  "%(color:red)%(authorname)"
                  "%(color:black)%(color:bold)%(refname:short)"
                ]
              }'"
              "refs/remotes"
              "|"
              "column -ts'|'"
            ];
          };

          extraConfig = {
            branch = {
              # Automatic remote tracking.
              autoSetupMerge = "always";
              # Automatically use rebase for new branches.
              autoSetupRebase = "always";
            };

            fetch = { prune = "true"; };
            pull = { rebase = "true"; };
            push = { default = "current"; };

            rebase = {
              # Support fixup and squash commits.
              autoSquash = "true";
              # Stash dirty worktree before rebase.
              autoStash = "true";
            };

            merge = {
              ff = "only";
              log = "true";
              conflictStyle = "diff3";
            };

            # Reuse recorded resolutions.
            rerere = {
              enabled = "true";
              autoUpdate = "true";
            };
          };
        };
      }
      (mkIf cfg.git.enableDelta {
        home.packages = [ pkgs.delta ];
        programs.git.extraConfig = {
          core.pager = "delta";
          interactive.diffFilter = "delta --color-only";
        };
      })
      (mkIf cfg.git.enableGhq {
        home.packages = [ pkgs.ghq ];
        programs.git.extraConfig = { ghq = { root = cfg.sourceDirectory; }; };
      })
      (mkIf cfg.git.gitHub.enable (mkMerge [
        { home.packages = [ pkgs.gh ]; }
        (mkIf cfg.git.gitHub.reuseSshConnection {
          programs.ssh = {
            enable = true;
            matchBlocks = {
              "github.com" = {
                hostname = "ssh.github.com";
                port = 443;
                serverAliveInterval = 60;
                extraOptions = {
                  ControlMaster = "auto";
                  ControlPersist = "yes";
                };
              };
            };
          };
        })
      ]))
    ]))

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

    (mkIf cfg.nix.enable {
      home.packages = with pkgs; [
        cachix
        manix
        nix-diff
        nix-du
        nix-index
        nix-prefetch-scripts
        nix-tree
        nixfmt
        rnix-lsp
      ];
    })

    (mkIf cfg.shell.enable {
      home.packages = with pkgs; [ shellcheck shfmt termtosvg ];

      programs.editorConfig.settings."*.{bash,sh}" = {
        indent_style = cfg.shell.indentStyle;
        indent_size = cfg.shell.indentSize;
      };
    })
  ]);
}
