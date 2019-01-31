{ lib, pkgs, ... }:

let
  homeDirectory = builtins.getEnv "HOME";
  nixDirectory = "${homeDirectory}/src/github.com/terlar/nix-config";
  emacsPackages = import ./emacs.nix pkgs;
  secrets = import ../load-secrets.nix;
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
        workMobDP = {
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
        workMobHDMI = {
          fingerprint = {
            HDMI1 = "00ffffffffffff004c2d080e00000e000e1b0103806639782a23ada4544d99260f474abdef80714f81c0810081809500a9c0b300010104740030f2705a80b0588a00baa84200001e000000fd00184b0f511e000a202020202020000000fc0053796e634d61737465720a2020000000ff004831414b3530303030300a20200102020340f0535f101f041305142021225d5e626364071603122309070783010000e2000fe30503016e030c001000b83c20008001020304e3060d01e50e60616566011d80d0721c1620102c2580501d7400009e662156aa51001e30468f3300501d7400001e023a801871382d40582c4500baa84200001e000000000000000000d1";
            eDP1 = "00ffffffffffff0009e5bf0600000000011a0104951c10780af6a0995951942d1f505400000001010101010101010101010101010101c93680cd703814403020360018a51000001ad42b80cd703814406464440518a51000001a000000fe004637375231804e5631324e343100000000000041119e001000000a010a202000ca";
          };
          config = {
            HDMI1 = {
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

    rofi = {
      enable = true;
      font = "monospace 16";
      separator = "solid";
      colors =
        let
          bg = "#273238";
            bgAlt = "#1e2529";
            bgHigh = "#394249";
            fg = "#c1c1c1";
            fgHigh = "#ffffff";
            fgActive = "#80cbc4";
            fgUrgent = "#ff1844";
          in {
            window = {
              background = bg;
              border = bg;
              separator = bgAlt;
            };

            rows = {
              normal = {
                foreground = fg;
                background = bg;
                backgroundAlt = bg;
                highlight = {
                  foreground = fgHigh;
                  background = bgHigh;
                };
              };
              active = {
                foreground = fgActive;
                background = bg;
                backgroundAlt = bg;
                highlight = {
                  foreground = fgActive;
                  background = bgHigh;
                };
              };
              urgent = {
                foreground = fgUrgent;
                background = bg;
                backgroundAlt = bg;
                highlight = {
                  foreground = fgUrgent;
                  background = bgHigh;
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
      inactiveInterval = 10;
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

      config = let
        modifier = "Mod4";
        fonts = [ "sans-serif 9" ];
        tile = "exec ${pkgs.scripts.window_tiler}/bin/window_tiler";
      in {
        # Autostart
        startup = [
          { command = "${pkgs.dex}/bin/dex -ae i3"; always = true; notification = false; }
        ];

        # UI
        inherit fonts;

        # Borders
        window.border = 0;
        floating.border = 3;

        # Gaps
        gaps = {
          inner = 5;
          outer = 0;
        };

        # Status bar
        bars = [
          {
            inherit fonts;
            statusCommand = "${pkgs.i3status}/bin/i3status";
            colors = {
              background = "#333333";
            };
          }
        ];

        # Desktops
        assigns = {
          "2" = [ { class = "^Firefox$"; } ];
          "9" = [ { class = "^Slack$"; } ];
        };

        # Floats
        floating.criteria = [
          { "class" = "Nm-connection-editor"; }
          { "class" = "Pavucontrol"; }
          { "class" = "Pinentry"; }
          { "class" = "^.*blueman-manager.*$"; }
        ];

        # Keybindings
        inherit modifier;
        floating.modifier = "${modifier}";

        modes = {
          move = {
            Up = "${tile} top-left; mode default";
            Left = "${tile} bottom-left; mode default";
            Down = "${tile} bottom-right; mode default";
            Right = "${tile} top-right; mode default";

            Escape = "mode default";
            Return = "mode default";
            "Ctrl+g" = "mode default";
          };

          resize = {
            "h" = "resize shrink width 10 px or 10 ppt";
            "j" = "resize grow height 10 px or 10 ppt";
            "k" = "resize shrink height 10 px or 10 ppt";
            "l" = "resize grow width 10 px or 10 ppt";

            Escape = "mode default";
            Return = "mode default";
            "Ctrl+g" = "mode default";
          };
        };

        keybindings = {
          "${modifier}+r" = "mode resize";
          "${modifier}+w" = "mode move";

          # Pulse Audio controls
          "XF86AudioRaiseVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume 1 +5%";
          "XF86AudioLowerVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume 1 -5%";
          "XF86AudioMute" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-mute 1 toggle";

          # Media player controls
          "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
          "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
          "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";

          # Sreen brightness controls
          "XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -Ap 2";
          "XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -Up 2";

          # Start a terminal
          "${modifier}+Return" = "exec i3-sensible-terminal";
          # Start program launcher
          "${modifier}+p" = "exec ${pkgs.rofi}/bin/rofi -show run";

          # Change container layout (stacked, tabbed, toggle split)
          "${modifier}+s" = "layout stacking";
          "${modifier}+t" = "layout tabbed";
          "${modifier}+e" = "layout toggle split";

          # Toggle split direction
          "${modifier}+v" = "split toggle";
          # Toggle fullscreen mode for the focused container
          "${modifier}+f" = "fullscreen toggle";
          # Toggle tiling / floating
          "${modifier}+Shift+space" = "floating toggle";

          # Scratchpad
          "${modifier}+grave" = "scratchpad show";
          "${modifier}+Shift+grave" = "move scratchpad";

          # Border
          "${modifier}+b" = "border toggle";
          # Sticky
          "${modifier}+z" = "sticky toggle";

          # PIP
          "${modifier}+Shift+z" = "mark pip,[con_mark=\"pip\"] move scratchpad,[con_mark=\"pip\"] sticky enable,resize shrink width 10000px,resize grow width 640px,resize shrink height 10000px,resize grow height 360px,move absolute position 10 px 10 px";
          # Move PIP window
          "${modifier}+Up" = "[con_mark=\"pip\"] focus,${tile} top-left && i3-msg 'focus tiling'";
          "${modifier}+Left" = "[con_mark=\"pip\"] focus,${tile} bottom-left && i3-msg 'focus tiling'";
          "${modifier}+Down" = "[con_mark=\"pip\"] focus,${tile} bottom-right && i3-msg 'focus tiling'";
          "${modifier}+Right" = "[con_mark=\"pip\"] focus,${tile} top-right && i3-msg 'focus tiling'";

          # Change focus between tiling / floating windows
          "${modifier}+space" = "focus mode_toggle";
          # Focus the parent container
          "${modifier}+a" = "focus parent";
          # Focus the child container
          "${modifier}+d" = "focus child";

          # Change focus
          "${modifier}+h" = "focus left";
          "${modifier}+j" = "focus down";
          "${modifier}+k" = "focus up";
          "${modifier}+l" = "focus right";

          # Move focused window
          "${modifier}+Shift+h" = "move left";
          "${modifier}+Shift+j" = "move down";
          "${modifier}+Shift+k" = "move up";
          "${modifier}+Shift+l" = "move right";

          # Switch to monitor
          "${modifier}+m" = "focus output up";
          # Move workspace to monitor
          "${modifier}+Shift+m" = "move workspace to output up";

          # Switch to workspace
          "${modifier}+bracketleft" = "workspace prev";
          "${modifier}+bracketright" = "workspace next";
          "${modifier}+Tab" = "workspace next";
          "${modifier}+Shift+Tab" = "workspace prev";
          "${modifier}+1" = "workspace 1";
          "${modifier}+2" = "workspace 2";
          "${modifier}+3" = "workspace 3";
          "${modifier}+4" = "workspace 4";
          "${modifier}+5" = "workspace 5";
          "${modifier}+6" = "workspace 6";
          "${modifier}+7" = "workspace 7";
          "${modifier}+8" = "workspace 8";
          "${modifier}+9" = "workspace 9";
          "${modifier}+0" = "workspace 10";

          # Move focused container to workspace
          "${modifier}+Shift+bracketleft" = "move container to workspace prev; workspace prev";
          "${modifier}+Shift+bracketright" = "move container to workspace next; workspace next";
          "${modifier}+Shift+1" = "move container to workspace 1";
          "${modifier}+Shift+2" = "move container to workspace 2";
          "${modifier}+Shift+3" = "move container to workspace 3";
          "${modifier}+Shift+4" = "move container to workspace 4";
          "${modifier}+Shift+5" = "move container to workspace 5";
          "${modifier}+Shift+6" = "move container to workspace 6";
          "${modifier}+Shift+7" = "move container to workspace 7";
          "${modifier}+Shift+8" = "move container to workspace 8";
          "${modifier}+Shift+9" = "move container to workspace 9";
          "${modifier}+Shift+0" = "move container to workspace 10";

          # Kill focused window
          "${modifier}+Shift+q" = "kill";

          # Reload the configuration file
          "${modifier}+Shift+c" = "reload";
          # Restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
          "${modifier}+Shift+r" = "restart";
          # Exit i3 (logs you out of your X session)
          "${modifier}+Shift+BackSpace" = "exec \"i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -b 'Yes, exit i3' 'i3-msg exit'\"";
        };
      };
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
