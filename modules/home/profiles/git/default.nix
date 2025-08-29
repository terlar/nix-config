{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkDefault mkIf mkMerge;

  cfg = config.profiles.git;
in
{
  imports = [ ./interface.nix ];

  config = mkIf cfg.enable (mkMerge [
    {
      programs = {
        git = {
          enable = true;
          ghq = {
            enable = mkDefault true;
            options = {
              root = mkDefault "~/src";
              "https://git.savannah.gnu.org/git/".vcs = "git";
            };
          };

          aliases = mkIf cfg.enableAliases {
            ignore = "update-index --assume-unchanged";
            unignore = "update-index --no-assume-unchanged";
            ignored = "!git ls-files -v | grep '^[[:lower:]]'";

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
              autoSetupMerge = mkDefault "simple";
              # Automatically use rebase for new branches.
              autoSetupRebase = mkDefault "always";
            };

            fetch.prune = mkDefault "true";
            pull.rebase = mkDefault "true";
            push = {
              autoSetupRemote = mkDefault "true";
              default = mkDefault "simple";
            };

            merge = {
              conflictStyle = mkDefault "zdiff3";
              ff = mkDefault "only";
              log = mkDefault "true";
            };

            rebase = {
              # Support fixup and squash commits.
              autoSquash = mkDefault "true";
              # Stash dirty worktree before rebase.
              autoStash = mkDefault "true";
            };

            # Reuse recorded resolutions.
            rerere = {
              enabled = mkDefault "true";
              autoUpdate = mkDefault "true";
            };
          };
        };

        ssh = {
          enable = mkDefault true;
          enableDefaultConfig = false;
          matchBlocks."*".compression = mkDefault true;
        };
      };
    }

    (mkIf cfg.github.enable {
      programs = {
        gh.enable = true;
        ssh.matchBlocks = mkIf cfg.github.reuseSshConnection {
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

    {
      home.packages = mkMerge [
        (mkIf cfg.absorb.enable [ pkgs.git-absorb ])
        (mkIf cfg.imerge.enable [ pkgs.git-imerge ])
      ];
    }
  ]);
}
