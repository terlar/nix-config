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
    systemd.user.startServices = "sd-switch";
    manual.html.enable = true;

    xdg = {
      enable = true;
      mimeApps.enable = true;
    };

    profiles = {
      user.terje.shell.enable = lib.mkDefault true;
      monochrome.enable = lib.mkDefault true;
      development = {
        enable = lib.mkDefault true;
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

      emacsConfig.enable = true;
    };

    nix = {
      package = lib.mkDefault pkgs.lix;

      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];

        # Build
        max-jobs = "auto";
        http-connections = lib.mkDefault 50;

        # Store
        auto-optimise-store = true;
        min-free = lib.mkDefault 1024;
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

      git = {
        ignores = [
          ".dir-locals.el"
          ".direnv/"
          ".envrc"
        ];

        extraConfig = {
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
            "ssh://git@github.com/terlar".insteadOf = "gh:terlar";
            "https://github.com/".insteadOf = "gh:";
          };
        };
      };
    };
  };
}
