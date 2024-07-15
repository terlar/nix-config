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
      profiles.gnupg.enable = mkDefault true;

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
        pkgs.jaq
        pkgs.nodePackages.json-diff
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
        home.packages = [ pkgs.git-imerge ];

        programs = {
          git = {
            enable = mkDefault true;

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

              fetch = {
                prune = "true";
              };
              pull = {
                rebase = "true";
              };
              push = {
                default = "current";
              };

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

          ssh = {
            enable = mkDefault true;
            compression = mkDefault true;
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
        programs.git.extraConfig = {
          ghq = {
            root = cfg.sourceDirectory;
            "https://git.savannah.gnu.org/git/" = {
              vcs = "git";
            };
          };
        };
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
      (mkIf cfg.nix.retainShellInNixShell {
        home.packages = [ pkgs.nix-your-shell ];
        programs.fish.interactiveShellInit = ''
          nix-your-shell fish | source
        '';
      })
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
