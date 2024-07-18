{ config, lib, ... }:

let
  inherit (lib) mkDefault mkIf;
  cfg = config.profiles.user.terje;
in
{
  options.profiles.user.terje = {
    enable = lib.mkEnableOption "User profile for Terje";
  };

  config = mkIf cfg.enable {
    profiles = {
      base.enable = true;

      monochrome.enable = mkDefault true;

      development = {
        enable = mkDefault true;

        diagramming.d2.enable = mkDefault true;

        nix.enable = mkDefault true;
        shell.enable = mkDefault true;
      };

      user.terje = {
        shell.enable = mkDefault true;
        editor.emacs.enable = mkDefault true;
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
    };

    nix.extraOptions = builtins.readFile ../../../../../dev/nix.conf;

    programs = {
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
          ".envrc"
        ];

        delta.options = {
          navigate = true;
          features = "decorations";
        };

        extraConfig.url = {
          "ssh://git@github.com/terlar".insteadOf = "gh:terlar";
          "https://github.com/".insteadOf = "gh:";
        };
      };
    };
  };
}
