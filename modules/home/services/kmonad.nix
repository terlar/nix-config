{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    types
    ;

  cfg = config.services.kmonad;

  keyboardOpts =
    { name, ... }:
    {
      options = {
        name = mkOption {
          type = types.str;
          readOnly = true;
          description = ''
            Unique name of the keyboard. This is set to the attribute name of the
            keyboard configuration.
          '';
        };

        enable = mkEnableOption "kmonad service for keyboard ${name}";

        config = mkOption {
          type = types.lines;
          default = "";
          description = ''
            The kmonad configuration for this keyboard.
          '';
        };
      };

      config = {
        name = mkDefault name;
      };
    };
in
{
  options.services.kmonad = {
    keyboards = mkOption {
      type = types.attrsOf (types.submodule keyboardOpts);
      default = { };
      description = "List of keyboard configurations.";
    };

    package = mkPackageOption pkgs "kmonad" { };
  };

  # NOTE: the top-level attrs assigned to config cannot be created by a fold or
  # merge over cfg.keyboards, it seems, as that results in an infinite
  # recursion.
  config =
    let
      enabledKeyboards = lib.filterAttrs (_name: kb: kb.enable) cfg.keyboards;
    in
    mkIf (cfg.keyboards != { }) {
      xdg.configFile = lib.mapAttrs' (
        name: kb: lib.nameValuePair "kmonad/kmonad-${name}.kbd" { text = kb.config; }
      ) enabledKeyboards;

      systemd.user.services = lib.mapAttrs' (
        name: _kb:
        lib.nameValuePair "kmonad-${name}" {
          Unit = {
            Description = "KMonad for ${name}";
          };
          Install = {
            WantedBy = [ "default.target" ];
          };
          Service = {
            Type = "simple";
            ExecStart = "${cfg.package}/bin/kmonad ${config.xdg.configFile."kmonad/kmonad-${name}.kbd".source}";
          };
        }
      ) enabledKeyboards;
    };
}
