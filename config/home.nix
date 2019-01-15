{ lib, pkgs, ... }:

let
  homeDirectory = builtins.getEnv "HOME";
  nixDirectory = "${homeDirectory}/src/github.com/terlar/nix-config";
  emacsPackages = import ./emacs.nix pkgs;
in rec {
  imports = [
  ] ++ lib.optional (builtins.pathExists ../private) ../private;

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
    packages = with pkgs; [
      i3lock-color
      i3status
    ];

    sessionVariables = {
      EDITOR = "${homeDirectory}/.nix-profile/bin/emacsclient";
      TERMINAL = "${pkgs.kitty}/bin/kitty";
    };

    file = {
      ".editorconfig".text = ''
        ${builtins.readFile ./dotfiles/editorconfig/.editorconfig}
      '';

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

      userName = "Terje Larsen";
      userEmail = "terlar@gmail.com";
      signing = {
        signByDefault = true;
        key = "89AF679B037E1D2A";
      };

      includes = [
        { path = "~/.config/git/config-private"; }
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

        "difftool \"ediff\"".cmd = "ediff \"$LOCAL\" \"$REMOTE\"";

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

    autorandr = {
      enable = true;
      profiles = {
        solo = {
          fingerprint = {
            eDP1 = "00ffffffffffff0009e5bf0600000000011a0104951c10780af6a0995951942d1f505400000001010101010101010101010101010101c93680cd703814403020360018a51000001ad42b80cd703814406464440518a51000001a000000fe004637375231804e5631324e343100000000000041119e001000000a010a202000ca";
          };
          config = {
            DP1.enable = false;
            eDP1 = {
              primary = true;
              position = "0x0";
              mode = "1920x1080";
              rate = "60.00";
            };
          };
        };
        home = {
          fingerprint = {
            DP1 = "00ffffffffffff0006102792ec18341534150104b53c2278226fb1a7554c9e250c505400000001010101010101010101010101010101565e00a0a0a029503020350055502100001a1a1d008051d01c204080350055502100001c000000ff00433032475835484e444a47520a000000fc005468756e646572626f6c740a2001b602030cc12309070783010000565e00a0a0a029503020350055502100001a1a1d008051d01c204080350055502100001c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000013";
            eDP1 = "00ffffffffffff0009e5bf0600000000011a0104951c10780af6a0995951942d1f505400000001010101010101010101010101010101c93680cd703814403020360018a51000001ad42b80cd703814406464440518a51000001a000000fe004637375231804e5631324e343100000000000041119e001000000a010a202000ca";
          };
          config = {
            DP1 = {
              enable = true;
              primary = true;
              position = "0x0";
              mode = "2560x1440";
              rate = "59.95";
            };
            eDP1 = {
              position = "0x1440";
              mode = "1920x1080";
              rate = "60.00";
            };
          };
        };
        work = {
          fingerprint = {
            DP1 = "00ffffffffffff004c2d080e00000e000e1b0103806639782a23ada4544d99260f474abdef80714f81c0810081809500a9c0b300010104740030f2705a80b0588a00baa84200001e000000fd00184b0f511e000a202020202020000000fc0053796e634d61737465720a2020000000ff004831414b3530303030300a20200102020340f0535f101f041305142021225d5e626364071603122309070783010000e2000fe30503016e030c001000b83c20008001020304e3060d01e50e60616566011d80d0721c1620102c2580501d7400009e662156aa51001e30468f3300501d7400001e023a801871382d40582c4500baa84200001e000000000000000000d1";
            eDP1 = "00ffffffffffff0009e5bf0600000000011a0104951c10780af6a0995951942d1f505400000001010101010101010101010101010101c93680cd703814403020360018a51000001ad42b80cd703814406464440518a51000001a000000fe004637375231804e5631324e343100000000000041119e001000000a010a202000ca";
          };
          config = {
            DP1 = {
              enable = true;
              primary = true;
              position = "0x0";
              mode = "1920x1080";
              rate = "60.00";
            };
            eDP1 = {
              position = "0x1080";
              mode = "1920x1080";
              rate = "60.00";
            };
          };
        };
      };
    };
  };

  services = {
    screen-locker = {
      enable = true;
      lockCmd = "${pkgs.i3lock-color}/bin/i3lock-color --clock --color=333333";
      inactiveInterval = 1;
    };

    gpg-agent = {
      enable = true;

      enableSshSupport = true;
      defaultCacheTtl = 600;
      maxCacheTtl = 7200;
    };

    pasystray.enable = true;
  };

  xsession = {
    enable = true;

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      config = null;
      extraConfig = ''
        ${builtins.readFile ./dotfiles/i3/.config/i3/config}
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
