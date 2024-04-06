# Code copied with slight modifications from @splintah at:
# https://github.com/splintah/configuration/blob/master/modules/home/kmonad.nix
{ config, lib, ... }:
with lib;
let
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

        enable = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Whether to enable the kmonad service for this keyboard.
          '';
        };

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

    package = mkOption {
      type = types.package;
      example = "pkgs.kmonad";
      description = ''
        The kmonad package.
      '';
    };
  };

  # NOTE: the top-level attrs assigned to config cannot be created by a fold or
  # merge over cfg.keyboards, it seems, as that results in an infinite
  # recursion.
  config =
    let
      enabledKeyboards = filterAttrs (_name: kb: kb.enable) cfg.keyboards;
    in
    mkIf (cfg.keyboards != { }) {
      xdg.configFile = mapAttrs' (
        name: kb: nameValuePair "kmonad/kmonad-${name}.kbd" { text = kb.config; }
      ) enabledKeyboards;

      systemd.user.services = mapAttrs' (
        name: _kb:
        nameValuePair "kmonad-${name}" {
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
