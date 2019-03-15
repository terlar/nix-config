{ config, pkgs, lib, ... }:

let
  homeManagerPath = ../home-manager;
  emacsPackages = import ./emacs.nix pkgs;
  data = import ../load-data.nix;
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
      map (n: import (path + ("/" + n))) (
        filter
        (n: match ".*\\.nix" n != null || pathExists (path + ("/" + n + "/default.nix")))
        (attrNames (readDir path)));
  };

  home = {
    sessionVariables = {
      EDITOR = "emacseditor";
      TERMINAL = "kitty";
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
      path = toString homeManagerPath;
    };

    direnv = {
      enable = true;
      stdlib = builtins.readFile ./home/common/direnv/stdlib.sh;
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

      userName = data.name;
      userEmail = data.email;
      signing = {
        signByDefault = if data.keys.gpg != "" then true else false;
        key = data.keys.gpg;
      };

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
        branches = ''
          !git for-each-ref \
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

        "difftool \"ediff\"".cmd = ''
          emacsclient --eval '(ediff-files "'$LOCAL'" "'$REMOTE'")'
        '';

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

        "mergetool \"ediff\"".cmd = ''
          emacsclient --eval '(ediff-merge-files-with-ancestor "'$LOCAL'" "'$REMOTE'" "'$BASE'" nil "'$MERGED'")'
        '';

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

      matchBlocks = {
        "github" = {
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

    configFile."i3status/config".source = ./dotfiles/i3/.config/i3status/config;
    configFile."kitty/kitty.conf".source = ./dotfiles/kitty/.config/kitty/kitty.conf;
    # Fish configuration.
    configFile."fish/completions".source = ./dotfiles/fish/.config/fish/completions;
    configFile."fish/conf.d".source = ./dotfiles/fish/.config/fish/conf.d;
    configFile."fish/functions".source = ./dotfiles/fish/.config/fish/functions;
  };

  manual.html.enable = true;
}
