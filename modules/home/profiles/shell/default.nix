{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.shell;
in
{
  imports = [ ./interface.nix ];

  config = lib.mkIf cfg.enable {
    profiles.shell.fish.enable = lib.mkDefault true;

    programs = {
      # In case you get dropped into a bash shell.
      bash.enable = lib.mkDefault true;

      readline.enable = lib.mkDefault true;

      # Display markdown files.
      glow.enable = lib.mkDefault true;
    };

    home.packages = [ pkgs.surfraw ];
  };
}
