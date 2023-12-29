{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) types;
  cfg = config.profiles.user.terje.terminal;

  packageMainProgram = cfg.package.mainProgram or "";
in {
  options.profiles.user.terje.terminal = {
    enable = lib.mkEnableOption "Terminal profile for terje";

    package = lib.mkOption {
      type = types.package;
      default = pkgs.foot;
      example = lib.literalExpression "pkgs.kitty";
      description = "Package providing terminal.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables.TERMINAL = packageMainProgram;

    programs.foot = lib.mkIf (packageMainProgram == "foot") {
      inherit (cfg) package;

      enable = true;
      server.enable = true;

      settings = {
        main = {
          font = "Iosevka Slab Light:size=10";
        };

        scrollback = {
          lines = 1000000;
        };

        mouse = {
          hide-when-typing = "yes";
        };

        search-bindings = {
          delete-next = "Control+d Delete";
        };

        colors = {
          foreground = "002b37";
          background = "fffce9";
          regular0 = "002b37"; # black
          regular1 = "bb3e06"; # red
          regular2 = "596e76"; # green
          regular3 = "98a6a6"; # yellow
          regular4 = "596e76"; # blue
          regular5 = "596e76"; # magenta
          regular6 = "596e76"; # cyan
          regular7 = "98a6a6"; # white
          bright0 = "596e76"; # bright black
          bright1 = "cc1f24"; # bright red
          bright2 = "002b37"; # bright green
          bright3 = "f4eedb"; # bright yellow
          bright4 = "002b37"; # bright blue
          bright5 = "002b37"; # bright magenta
          bright6 = "002b37"; # bright cyan
          bright7 = "f4eedb"; # bright white
        };
      };
    };
  };
}
