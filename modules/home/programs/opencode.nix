{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkOption types;

  cfg = config.module.opencode;
in
{
  options.module.opencode = {
    enable = mkEnableOption "OpenCode AI coding agent";

    package = mkOption {
      type = types.package;
      default = pkgs.opencode;
      description = "The open source AI coding agent";
    };

    settings = mkOption {
      type = types.attrs;
      default = { };
      description = "OpenCode configuration settings";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."opencode/opencode.json".text = builtins.toJSON (
      { "$schema" = "https://opencode.ai/config.json"; } // cfg.settings
    );
  };
}
