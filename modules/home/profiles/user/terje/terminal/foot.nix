{ config, lib, ... }:

let
  inherit (lib)
    mkDefault
    mkIf
    mkOption
    types
    ;

  cfg = config.profiles.user.terje.terminal.foot;
in
{
  options.profiles.user.terje.terminal.foot = {
    enable = lib.mkEnableOption "Foot terminal profile for Terje";
    defaultTerminal = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to configure {command}`foot` as the default
          terminal using the {env}`TERMINAL` environment variable.
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.foot = {
      enable = true;
      server.enable = mkDefault true;

      settings = {
        main = {
          font = "Iosevka Curly Slab Light:size=10";
          pad = "10x10";
          line-height = 14;
        };

        scrollback.lines = 1000000;

        mouse.hide-when-typing = "yes";

        search-bindings = {
          delete-next = "Control+d Delete";
        };
      };
    };

    home.sessionVariables = mkIf cfg.defaultTerminal {
      TERMINAL = lib.getExe config.programs.foot.package;
    };
  };
}
