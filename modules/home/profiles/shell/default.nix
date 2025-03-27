{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkDefault mkIf;
  cfg = config.profiles.shell;
in
{
  imports = [ ./interface.nix ];

  config = mkIf cfg.enable {
    profiles.shell.fish.enable = mkDefault true;

    programs = {
      # In case you get dropped into a bash shell.
      bash.enable = mkDefault true;

      readline.enable = mkDefault true;

      # Display source files.
      bat.enable = mkDefault true;

      # Display markdown files.
      glow.enable = mkDefault true;

      # Fast grep.
      ripgrep = {
        enable = mkDefault true;
        arguments = [
          "--max-columns=150"
          "--max-columns-preview"
          "--glob=!.git/*"
          "--smart-case"
        ];
      };
      ripgrep-all.enable = mkDefault true;
    };

    home.packages = [
      pkgs.fd
      pkgs.fzy
      pkgs.surfraw
      pkgs.tldr
      pkgs.tree
      pkgs.units
    ];
  };
}
