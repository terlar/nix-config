{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.user.terje.base;
in
{
  options.profiles.user.terje.base = {
    enable = lib.mkEnableOption "Base profile for terje";
  };

  config = lib.mkIf cfg.enable {
    home.stateVersion = "20.09";

    systemd.user.startServices = "sd-switch";
    manual.html.enable = true;

    xdg = {
      enable = true;
      mimeApps.enable = true;
    };

    profiles = {
      user.terje.shell.enable = lib.mkDefault true;

      gnupg.enable = lib.mkDefault true;
      development = {
        enable = lib.mkDefault true;
        javascript.enable = lib.mkDefault true;
        python.enable = lib.mkDefault true;
        nix.enable = lib.mkDefault true;
        shell.enable = lib.mkDefault true;
      };
    };

    custom = {
      keyboard = {
        enable = true;
        layouts = [
          { layout = "us"; }
          { layout = "se"; }
        ];
        xkbOptions = [ "ctrl:nocaps" ];
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
      extraOptions = builtins.readFile ../../../../../dev/nix.conf;
    };

    programs = {
      home-manager.enable = true;

      aspell = {
        enable = true;
        dictionaries = ps: [
          ps.en
          ps.sv
        ];
      };

      bat.config = {
        theme = "GitHub";
        pager = "less -FR";
      };

      git = {
        ignores = [
          ".dir-locals.el"
          ".direnv/"
          ".envrc"
        ];

        extraConfig = {
          ghq = {
            "git@code.orgmode.org:" = {
              vcs = "git";
            };
            "https://git.savannah.gnu.org/git/" = {
              vcs = "git";
            };
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
            "ssh://git@github.com/terlar" = {
              insteadOf = "gh:terlar";
            };
            "https://github.com/" = {
              insteadOf = "gh:";
            };
          };
        };
      };

      password-store = {
        enable = true;
        package = pkgs.pass.withExtensions (ext: [
          ext.pass-import
          ext.pass-genphrase
          ext.pass-update
          ext.pass-otp
        ]);
      };

      readline.enable = true;

      ssh = {
        enable = true;
        compression = true;
      };
    };

    home.packages = [
      # media
      pkgs.playerctl
      pkgs.surfraw
      pkgs.youtube-dl

      # utility
      pkgs.browsh
      pkgs.fzy
      pkgs.pdfgrep
      pkgs.tldr
      pkgs.units
      pkgs.unzip
      pkgs.xsv
    ];
  };
}
