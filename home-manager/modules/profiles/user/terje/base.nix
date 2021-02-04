{ config, dotfiles, lib, pkgs, ... }:

with builtins;
with lib;

let
  cfg = config.profiles.user.terje.base;

  sourceDirFiles = attrRoot: destination: target: {
    ${attrRoot} = foldl' (attrs: file:
      attrs // {
        "${destination}/${file}".source = "${toString target}/${file}";
      }) { } (attrNames (readDir target));
  };
in {
  options.profiles.user.terje.base = {
    enable = mkEnableOption "Base profile for terje";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs.home-manager.enable = true;
      systemd.user.startServices = "sd-switch";
      manual.html.enable = true;

      xdg.enable = true;
      xdg.mimeApps.enable = true;

      profiles = {
        development = {
          enable = true;
          aws.enable = true;
          javascript.enable = true;
          python.enable = true;
          shell.enable = true;
        };
      };

      custom = {
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

      programs.bat.config = {
        theme = "GitHub";
        pager = "less -FR";
      };

      programs.readline.enable = true;

      programs.ssh = {
        enable = true;
        compression = true;
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
        ];

        interactiveShellInit = ''
          if not set -Uq __fish_universal_config_done
             fish_load_colors
             fish_user_abbreviations
             set -U __fish_universal_config_done 1
          end

          any-nix-shell fish | source

          set -x DIRENV_LOG_FORMAT ""

          if set -q IN_NIX_SHELL
            function __direnv_export_eval
              # Don't trigger within nix-shell
            end
          end
        '';
      };

      xdg = mkMerge [
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
        ignores = [ ".dir-locals.el" ".direnv/" ".envrc" ];

        extraConfig = {
          ghq = {
            "git@code.orgmode.org:" = { vcs = "git"; };
            "https://git.savannah.gnu.org/git/" = { vcs = "git"; };
          };

          delta = {
            features = "side-by-side line-numbers decorations";
            syntax-theme = "ansi-light";
          };

          url = {
            "ssh://git@github.com/terlar" = { insteadOf = "gh:terlar"; };
            "https://github.com/" = { insteadOf = "gh:"; };
          };
        };
      };
    }

    # GPG
    {
      programs.gpg = {
        enable = true;
        settings = { keyserver = "hkps://keys.openpgp.org"; };
      };

      services.gpg-agent = {
        enable = true;
        enableSshSupport = true;
      };
    }

    # Packages
    {
      home.packages = with pkgs; [
        scripts.insomnia
        scripts.themepark

        # nix
        any-nix-shell

        # media
        playerctl
        surfraw
        youtube-dl

        # utility
        browsh
        fzy
        htop
        menu
        pdfgrep
        pywal
        tldr
        units
        xsv
      ];
    }
  ]);
}
