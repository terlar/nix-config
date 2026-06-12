{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.profiles.user.terje.programs.mcp;
in
{
  options.profiles.user.terje.programs.mcp = {
    enable = lib.mkEnableOption "MCP configuration for Terje";
  };

  config = lib.mkIf cfg.enable {
    programs.mcp = {
      enable = true;
      servers = {
        k8s = {
          type = "local";
          enabled = false;
          command = "${pkgs.mcp-k8s-go}/bin/mcp-k8s-go";
        };

        nix = {
          type = "local";
          command = "${pkgs.mcp-nixos}/bin/mcp-nixos";
        };
      };
    };
  };
}
