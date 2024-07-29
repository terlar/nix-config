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
    mkMerge
    ;

  cfg = config.profiles.nix;
in
{
  options.profiles.nix = {
    enable = mkEnableOption "nix profile";
    enableNixOutputMonitor = mkEnableOption "Nix Output Monitor";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      nix = {
        package = mkDefault pkgs.lix;
        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];

          # Build
          max-jobs = mkDefault "auto";
          http-connections = mkDefault 50;

          # Store
          auto-optimise-store = mkDefault true;
          min-free = mkDefault 1024;
        };
      };

      programs = {
        fish.shellAbbrs = {
          n = "nix";
          ndrv = "nix derivation show";
          nf = "nix search nixpkgs";
          nl = "nix log";
          nr = "nix run";
        };

        nix-your-shell.enable = mkDefault true;
      };
    }

    (mkIf cfg.enableNixOutputMonitor {
      home.packages = [ pkgs.nix-output-monitor ];

      programs.fish.shellAbbrs = {
        nb = "nom build";
        nd = "nom develop";
        ns = "nom shell";
      };

      xdg.configFile."fish/completions/nom.fish".text = ''
        complete --command nom --wraps nix
      '';
    })
  ]);
}
