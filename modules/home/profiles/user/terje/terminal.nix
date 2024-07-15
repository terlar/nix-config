{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) types;
  cfg = config.profiles.user.terje.terminal;

  packageMainProgram = cfg.package.mainProgram or cfg.package.pname;
in
{
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
          font = "Iosevka Curly Slab Light:size=10";
          pad = "10x10";
          line-height = 14;
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
      };
    };
  };
}
