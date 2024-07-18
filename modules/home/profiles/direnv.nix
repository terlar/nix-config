{ config, lib, ... }:

let
  inherit (lib) mkDefault mkIf;

  cfg = config.profiles.direnv;
in
{
  options.profiles.direnv = {
    enable = lib.mkEnableOption "direnv profile";
  };

  config = mkIf cfg.enable {
    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = mkDefault true;
      };

      git.ignores = [ ".direnv/" ];
    };
  };
}
