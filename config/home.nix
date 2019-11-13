{ config, pkgs, lib, ... }:

let
  homeManagerPath = ../home-manager;
  data = import ../load-data.nix;
  sysconfig = (import <nixpkgs/nixos> {}).config;
in rec {
  imports = [
    ./emacs
  ] ++ lib.optionals sysconfig.services.xserver.enable [
    ./home/linux/autorandr.nix
    ./home/linux/gtk.nix
    ./home/linux/i3.nix
    ./home/linux/rofi.nix
  ] ++ lib.optional (builtins.pathExists ../private/home/default.nix) ../private/home;

  # Configuration for nixpkgs within `home-manager` evaluation.
  nixpkgs.config = import ./nixpkgs.nix;

  home = {
    sessionVariables = {
      BROWSER = "qutebrowser";
      TERMINAL = "kitty";
    };

    file = {
      ".editorconfig".source = ./dotfiles/editorconfig/.editorconfig;
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

    git = {
      enable = true;

      userName = data.name;
      userEmail = data.email;
      signing = {
        signByDefault = if data.keys.gpg != "" then true else false;
        key = data.keys.gpg;
      };

      ignores = [
        ".dir-locals.el"
        ".direnv/"
        ".envrc"
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

    gpg = {
      enable = true;
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

  xdg = {
    enable = true;

    # Configuration for nixpkgs outside `home-manager`, such as `nix-env`.
    configFile."nixpkgs/config.nix".source = ./nixpkgs.nix;

    # Fish configuration.
    configFile."fish/completions".source = ./dotfiles/fish/.config/fish/completions;
    configFile."fish/conf.d".source = ./dotfiles/fish/.config/fish/conf.d;
    configFile."fish/functions".source = ./dotfiles/fish/.config/fish/functions;

    configFile."i3status/config".source = ./dotfiles/i3/.config/i3status/config;
    configFile."kitty/kitty.conf".source = ./dotfiles/kitty/.config/kitty/kitty.conf;
    configFile."qutebrowser/config.py".source = ./dotfiles/qutebrowser/.config/qutebrowser/config.py;

    configFile."mimeapps.list".text = ''
      [Default Applications]
      x-scheme-handler/http=org.qutebrowser.qutebrowser.desktop;
      x-scheme-handler/https=org.qutebrowser.qutebrowser.desktop;
      x-scheme-handler/ftp=org.qutebrowser.qutebrowser.desktop;
      x-scheme-handler/mailto=emacsmail.desktop;
      application/pdf=emacsclient.desktop;
    '';

    configFile."luakit/userconf.lua".text = ''
      local vertical_tabs = require "vertical_tabs"

      local settings = require "settings"
      settings.vertical_tabs.sidebar_width = 120

      local select = require "select"
      select.label_maker = function ()
        local chars = interleave("asdfg", "hjkl")
        return trim(sort(reverse(chars)))
      end
    '';
  };

  manual.html.enable = true;
}
