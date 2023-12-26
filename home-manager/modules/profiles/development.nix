{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkDefault
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    types
    ;

  cfg = config.profiles.development;

  mkIndentStyleOption = lang: default:
    mkOption {
      type = types.enum ["space" "tab"];
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

    sourceDirectory = mkOption {
      type = types.either types.path types.str;
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
        default = false;
        description = ''
          Whether to use `delta` for diff outputs.
          See <https://github.com/dandavison/delta>.
        '';
      };

      enableGhq = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to use `ghq` for remote repository management.
          See <https://github.com/x-motemen/ghq>.
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

    nix = {enable = mkEnableOption "Nix Development profile";};

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
        pkgs.fd
        pkgs.tree

        pkgs.hey
        pkgs.xh

        pkgs.gron
        pkgs.jq
        pkgs.nodePackages.json-diff

        pkgs.glow
        pkgs.graphviz
        pkgs.plantuml
      ];

      programs = {
        bat.enable = mkDefault true;

        direnv = {
          enable = mkDefault true;
          nix-direnv.enable = mkDefault true;
        };

        ripgrep = {
          enable = mkDefault true;
          enableRipgrepAll = mkDefault true;
          arguments = [
            "--max-columns=150"
            "--max-columns-preview"
            "--glob=!.git/*"
            "--smart-case"
          ];
        };
      };
    }

    (mkIf cfg.git.enable (mkMerge [
      {
        home.packages = [pkgs.git-imerge];

        programs.git = {
          enable = mkDefault true;
          package = mkDefault pkgs.gitFull;

          aliases = {
            ignore = "update-index --assume-unchanged";
            unignore = "update-index --no-assume-unchanged";
            ignored = "!git ls-files -v | grep '^[[:lower:]]'";
            wip = "!git add -Ap && git commit --amend --no-edit && git push --force-with-lease";

            fup = "!git log --stat --since '1 day ago' --author $(git config user.email)";
            tags = "tag -l";
            remotes = "remote -v";
            branches = builtins.concatStringsSep " " [
              "!git"
              "for-each-ref"
              "--sort=-committerdate"
              "--format='${
                builtins.concatStringsSep "|" [
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

            fetch = {prune = "true";};
            pull = {rebase = "true";};
            push = {default = "current";};

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
        home.packages = [pkgs.delta];
        programs.git.extraConfig = {
          core.pager = "delta";
          interactive.diffFilter = "delta --color-only";
        };
      })
      (mkIf cfg.git.enableGhq {
        home.packages = [pkgs.ghq];
        programs.git.extraConfig = {ghq = {root = cfg.sourceDirectory;};};
      })
      (mkIf cfg.git.gitHub.enable (mkMerge [
        {home.packages = [pkgs.gh];}
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
      home = {
        packages = [
          pkgs.nodePackages.jsonlint
          pkgs.nodePackages.prettier
        ];

        file = {
          ".npmrc".text = ''
            ${lib.optionalString cfg.javascript.ignoreScripts ''
              ignore-scripts=true
            ''}
          '';
          ".yarnrc".text = ''
            disable-self-update-check true
            ${lib.optionalString cfg.javascript.ignoreScripts ''
              ignore-scripts true
            ''}
          '';
        };
      };

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

    (mkIf cfg.nix.enable {
      home.packages = [
        pkgs.cachix
        pkgs.manix
        pkgs.nil
        pkgs.nix-diff
        pkgs.nix-du
        pkgs.nix-index
        pkgs.nix-init
        pkgs.nix-tree
        pkgs.nurl
      ];
    })

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
