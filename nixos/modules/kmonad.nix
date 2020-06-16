{ config, lib, pkgs, ... }:

with pkgs;
with lib;

let
  cfg = config.services.kmonad;
  configFile = writeTextFile {
    name = "default.kbd";
    text = ''
      ${cfg.extraConfig}
    '';
  };
in {
  options = {
    services.kmonad = {
      enable = mkEnableOption "KMonad advanced keyboard manager";

      extraConfig = mkOption {
        default = "";
        type = types.lines;
        description = ''
          Extra config to append to default.kbd
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.kmonad-bin;
        defaultText = "pkgs.kmonad-bin";
        example = literalExample "pkgs.kmonad";
        description = ''
          The KMonad derivation to use.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.kmonad = {
      description = "KMonad advanced keyboard manager";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/kmonad ${configFile}";
      };
    };
  };
}
