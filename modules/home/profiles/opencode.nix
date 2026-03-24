{ config, lib, ... }:

let
  inherit (lib) mkIf;
  cfg = config.profiles.opencode;
in
{
  options.profiles.opencode = {
    enable = lib.mkEnableOption "OpenCode profile";
  };

  config = mkIf cfg.enable {
    programs.opencode = {
      enable = true;
      settings = {
        autoshare = false;
        autoupdate = false;
        experimental = {
          disable_paste_summary = true;
        };
        share = "disabled";
      };
    };
  };
}
