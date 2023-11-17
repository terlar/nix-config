{
  config,
  dotfiles,
  lib,
  pkgs,
  ...
}: let
  cfg = config.profiles.user.terje.base;

  sourceDirFiles = attrRoot: destination: target: {
    ${attrRoot} = builtins.foldl' (attrs: file:
      attrs
      // {
        "${destination}/${file}".source = "${toString target}/${file}";
      }) {} (builtins.attrNames (builtins.readDir target));
  };
in {
  options.profiles.user.terje.base = {
    enable = lib.mkEnableOption "Base profile for terje";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      home.stateVersion = "20.09";

      programs.home-manager.enable = true;
      systemd.user.startServices = "sd-switch";
      manual.html.enable = true;

      xdg.enable = true;
      xdg.mimeApps.enable = true;

      profiles = {
        user.terje.keyboards.enable = lib.mkDefault true;

        development = {
          enable = lib.mkDefault true;
          aws.enable = lib.mkDefault true;
          javascript.enable = lib.mkDefault true;
          python.enable = lib.mkDefault true;
          nix.enable = lib.mkDefault true;
          shell.enable = lib.mkDefault true;
        };
      };

      home.sessionVariables.LS_COLORS = "1";

      custom = {
        keyboard = {
          enable = true;
          layouts = [{layout = "us";} {layout = "se";}];
          xkbOptions = ["ctrl:nocaps"];
          repeatDelay = 500;
          repeatInterval = 33; # 30Hz
        };

        keybindings = {
          enable = true;
          mode = "emacs";
        };

        emacsConfig = {
          enable = true;
          defaultEmailApplication = true;
          defaultPdfApplication = true;
        };
      };
    }

    {
      programs = {
        bat.config = {
          theme = "GitHub";
          pager = "less -FR";
        };

        readline.enable = true;

        ssh = {
          enable = true;
          compression = true;
        };
      };
    }

    # Bash
    {
      programs.bash.enable = true;
      home.packages = [
        pkgs.bashInteractive
      ];
    }

    # Fish
    {
      programs.fish = {
        enable = true;
        plugins = [
          {
            name = "aws";
            src = pkgs.fetchFromGitHub {
              owner = "terlar";
              repo = "plugin-aws";
              rev = "142c68b2828de93730d00b2b0421242df128e8fc";
              sha256 = "1cgyhjdh29jfly875ly31cjsymi45b3qipydsd9mvb1ws0r6337c";
              # date = 2020-04-22T09:47:07+02:00;
            };
          }
          {
            name = "kubectl-completions";
            src = pkgs.fetchFromGitHub {
              owner = "evanlucas";
              repo = "fish-kubectl-completions";
              rev = "bbe3b831bcf8c0511fceb0607e4e7511c73e8c71";
              sha256 = "1r6wqvvvb755jkmlng1i085s7cj1psxmddqghm80x5573rkklfps";
              # date = 2021-01-21T11:57:06-06:00;
            };
          }
          {
            name = "google-cloud-sdk-completions";
            src = pkgs.fetchFromGitHub {
              owner = "lgathy";
              repo = "google-cloud-sdk-fish-completion";
              rev = "bc24b0bf7da2addca377d89feece4487ca0b1e9c";
              sha256 = "03zzggi64fhk0yx705h8nbg3a02zch9y49cdvzgnmpi321vz71h4";
              # date = "2016-11-05T11:35:26+01:00";
            };
          }
        ];

        interactiveShellInit = ''
          if not set -Uq __fish_universal_config_done
             fish_load_colors
             set -U __fish_universal_config_done 1
          end

          set -x DIRENV_LOG_FORMAT ""

          function __direnv_disable_in_nix_shell --on-event fish_prompt
            if set -q IN_NIX_SHELL
              functions --erase __direnv_export_eval
            end
          end
        '';
      };

      xdg = lib.mkMerge [
        (sourceDirFiles "configFile" "fish/completions"
          "${dotfiles}/fish/.config/fish/completions")
        (sourceDirFiles "configFile" "fish/conf.d"
          "${dotfiles}/fish/.config/fish/conf.d")
        (sourceDirFiles "configFile" "fish/functions"
          "${dotfiles}/fish/.config/fish/functions")
      ];
    }

    # Git
    {
      programs.git = {
        ignores = [".dir-locals.el" ".direnv/" ".envrc"];

        extraConfig = {
          ghq = {
            "git@code.orgmode.org:" = {vcs = "git";};
            "https://git.savannah.gnu.org/git/" = {vcs = "git";};
          };

          delta = {
            features = "decorations";

            syntax-theme = "none";
            zero-style = "grey";
            minus-emph-style = "strike bold";
            minus-style = "strike";
            plus-emph-style = "bold italic";
            plus-style = "bold";
            line-numbers-minus-style = "red";
            line-numbers-plus-style = "bold";
          };

          url = {
            "ssh://git@github.com/terlar" = {insteadOf = "gh:terlar";};
            "https://github.com/" = {insteadOf = "gh:";};
          };
        };
      };
    }

    # GPG
    {
      programs.gpg = {
        enable = true;
        settings = {keyserver = "hkps://keys.openpgp.org";};
      };

      services.gpg-agent = {
        enable = true;
        enableSshSupport = true;
        extraConfig = ''
          allow-emacs-pinentry
          allow-loopback-pinentry
        '';
      };

      programs.fish.interactiveShellInit = ''
        set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
      '';
    }

    # Nix
    {
      home.packages = [
        pkgs.nix-your-shell
      ];

      nix = {
        package = lib.mkDefault pkgs.nixVersions.stable;
        settings = {
          # Build
          max-jobs = "auto";
          http-connections = 50;

          # Store
          auto-optimise-store = true;
          min-free = 1024;
        };
        extraOptions = builtins.readFile ../../../../../nix.conf;
      };

      programs.fish.interactiveShellInit = ''
        nix-your-shell fish | source
      '';
    }

    # Packages
    {
      home.packages = with pkgs; [
        themepark

        # media
        playerctl
        surfraw
        youtube-dl

        # utility
        browsh
        fzy
        pdfgrep
        pywal
        tldr
        units
        xsv
      ];
    }
  ]);
}
