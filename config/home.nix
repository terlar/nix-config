{ config, pkgs, lib, ... }:

let
  homeDirectory = builtins.getEnv "HOME";
  nixDirectory = "${homeDirectory}/src/github.com/terlar/nix-config";
  emacsPackages = import ./emacs.nix pkgs;
  secrets = import ../load-secrets.nix;
  sysconfig = (import <nixpkgs/nixos> {}).config;
in rec {
  imports = [
  ] ++ lib.optionals sysconfig.services.xserver.enable [
    ./home/linux/autorandr.nix
    ./home/linux/i3.nix
    ./home/linux/rofi.nix
  ] ++ lib.optional (builtins.pathExists ../private/home.nix) ../private/home.nix;

  nixpkgs = {
    config = {
      allowUnfree = true;
    };

    overlays =
      let path = ../overlays; in with builtins;
      map (n: import (path + ("/" + n)))
      (filter (n: match ".*\\.nix" n != null ||
        pathExists (path + ("/" + n + "/default.nix")))
        (attrNames (readDir path)));
  };

  home = {
    sessionVariables = {
      EDITOR = "${homeDirectory}/.nix-profile/bin/emacsclient";
      TERMINAL = "${pkgs.kitty}/bin/kitty";
    };

    file = {
      ".editorconfig".source = ./dotfiles/editorconfig/.editorconfig;

      ".emacs.d/init.el".source = pkgs.runCommand "init.el" {} ''
        cp ${./emacs.d/init.org} init.org
        ${pkgs.emacs}/bin/emacs --batch ./init.org -f org-babel-tangle
        mv init.el $out
      '';
      ".emacs.d/lisp".source = ./emacs.d/lisp;
      ".emacs.d/snippets".source = ./emacs.d/snippets;
      ".emacs.d/templates".source = ./emacs.d/templates;
    };
  };

  programs = {
    home-manager = {
      enable = true;
      path = "${nixDirectory}/home-manager";
    };

    direnv = {
      enable = true;

      stdlib = ''
        use_nix() {
            set -e

            local shell="shell.nix"
            if [[ ! -f "$shell" ]]; then
                shell="default.nix"
            fi

            if [[ ! -f "$shell" ]]; then
                fail "use nix: shell.nix or default.nix not found in the folder"
            fi

            local dir="$PWD"/.direnv
            local default="$dir/default"
            if [[ ! -L "$default" ]] || [[ ! -d `readlink "$default"` ]]; then
                local wd="$dir/env-`md5sum "$shell" | cut -c -32`" # TODO: Hash also the nixpkgs version?
                mkdir -p "$wd"

                local drv="$wd/env.drv"
                if [[ ! -f "$drv" ]]; then
                    log_status "use nix: deriving new environment"
                    IN_NIX_SHELL=1 nix-instantiate --add-root "$drv" --indirect "$shell" > /dev/null
                    nix-store -r `nix-store --query --references "$drv"` --add-root "$wd/dep" --indirect > /dev/null
                fi

                rm -f "$default"
                ln -s `basename "$wd"` "$default"
            fi

            local drv=`readlink -f "$default/env.drv"`
            local dump="$dir/dump-`md5sum ".envrc" | cut -c -32`-`md5sum $drv | cut -c -32`"

            if [[ ! -f "$dump" ]] || [[ "$XDG_CONFIG_DIR/direnv/direnvrc" -nt "$dump" ]]; then
                log_status "use nix: updating cache"

                old=`find "$dir" -name 'dump-*'`
                nix-shell "$drv" --show-trace "$@" --run 'direnv dump' > "$dump"
                rm -f $old
                fi

                direnv_load cat "$dump"

                watch_file "$default"
                watch_file shell.nix
                if [[ $shell == "default.nix" ]]; then
                watch_file default.nix
                fi
        }
      '';
    };

    fish = {
      enable = true;
    };

    emacs = {
      enable = true;
      package = pkgs.emacsHEAD;
      extraPackages = emacsPackages;
      overrides = pkgs.emacsOverrides;
    };

    git = {
      enable = true;

      userName = secrets.fullName;
      userEmail = secrets.email;
      signing = {
        signByDefault = true;
        key = secrets.gpgKey;
      };

      includes = [
        { path = "~/.config/git/config-private"; }
      ];

      ignores = [
        ".envrc"
        ".direnv/"
      ];

      aliases = {
        unstage = "reset HEAD";
        uncommit = "reset --soft HEAD^";
        unpush = "push --force-with-lease origin HEAD^:master";
        recommit = "commit --amend";
        ignore = "update-index --assume-unchanged";
        unignore = "update-index --no-assume-unchanged";
        ignored = "!git ls-files -v | grep '^[[:lower:]]'";

        tags = "tag -l";
        remotes = "remote -v";
        branches = ''!git for-each-ref \
          --sort=-committerdate \
          --format='%(color:blue)%(authordate:relative)\t \
          %(color:red)%(authorname)\t \
          %(color:black)%(color:bold)%(refname:short)' \
          refs/remotes \
          | column -ts'\t'
        '';

        fup = "!git --no-pager log --stat --since '1 day ago' --author $(git config user.email)";
        head = "!git --no-pager log --stat -1";
        recent = "!git log --stat -30";
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
          recurseSubmodules = "true";
        };

        pull = {
          rebase = "true";
        };

        push = {
          default = "simple";
        };

        diff = {
          submodule = "log";
          tool = "ediff";
        };

        difftool = {
          prompt = "false";
        };

        "difftool \"ediff\"".cmd = "ediff $LOCAL $REMOTE";

        rebase = {
          # Support fixup and squash commits.
          autoSquash = "true";
          # Stash dirty worktree before rebase.
          autoStash = "true";
        };

        merge = {
          ff = "only";
          log = "true";
          tool = "ediff";
          conflictStyle = "diff3";
        };

        mergetool = {
          prompt = "false";
          keepBackup = "false";
        };

        "mergetool \"ediff\"".cmd =
          "emacsclient --eval '(ediff-merge-files-with-ancestor \\\"'$LOCAL'\\\" \\\"'$REMOTE'\\\" \\\"'$BASE'\\\" nil \\\"'$MERGED'\\\")'";

        # Reuse recorded resolutions.
        rerere = {
          enabled = "true";
          autoUpdate = "true";
        };

        ghq = {
          root = "~/src";
        };

        "url \"ssh://git@github.com/terlar\"" = {
          insteadOf = "https://github.com/terlar";
        };
      };
    };

    ssh = {
      enable = true;

      compression = true;
      extraOptionOverrides = {
        Include = "~/.ssh/config_private";
      };

      matchBlocks = {
        "github" = {
          hostname = "ssh.github.com";
          port = 443;
          extraOptions = {
            ControlMaster = "auto";
            ControlPersist = "yes";
          };
        };
      };
    };
  };

  services = {
    emacs = {
      enable = true;
    };

    gpg-agent = {
      enable = true;

      enableSshSupport = true;
      defaultCacheTtl = 600;
      maxCacheTtl = 7200;

      extraConfig = ''
        allow-emacs-pinentry
      '';
    };
  };

  xdg = {
    enable = true;

    configHome = "${homeDirectory}/.config";
    dataHome   = "${homeDirectory}/.local/share";
    cacheHome  = "${homeDirectory}/.cache";

    configFile."i3status/config".source = ./dotfiles/i3/.config/i3status/config;
    configFile."kitty/kitty.conf".source = ./dotfiles/kitty/.config/kitty/kitty.conf;
    # Fish configuration.
    configFile."fish/completions".source = ./dotfiles/fish/.config/fish/completions;
    configFile."fish/conf.d".source = ./dotfiles/fish/.config/fish/conf.d;
    configFile."fish/functions".source = ./dotfiles/fish/.config/fish/functions;
  };
}
