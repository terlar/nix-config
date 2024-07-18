{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkDefault;

  cfg = config.profiles.nix;
in
{
  options.profiles.nix = {
    enable = lib.mkEnableOption "nix profile";
  };

  config = lib.mkIf cfg.enable {
    nix = {
      package = lib.mkDefault pkgs.lix;
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];

        # Build
        max-jobs = lib.mkDefault "auto";
        http-connections = lib.mkDefault 50;

        # Store
        auto-optimise-store = lib.mkDefault true;
        min-free = lib.mkDefault 1024;
      };
    };

    programs = {
      nix-your-shell.enable = mkDefault true;
    };
  };
}
