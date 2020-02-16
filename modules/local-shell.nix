{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.local.shell;
in {
  options.local.shell = {
    enable = mkEnableOption "Enables shell.";

    package = mkOption {
      type = types.shellPackage;
      default = pkgs.fish;
      defaultText = "pkgs.fish";
      example = literalExample "pkgs.zsh";
      description = "The Shell derivation to use";
    };

    defaultUserShell = mkOption {
      type = types.bool;
      default = true;
      description = "Set the shell as default user shell.";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment = {
        variables.SHELL = "${cfg.package}${cfg.package.shellPath}";
      };
    }

    (mkIf (cfg.package.pname == "fish") {
      programs.fish.enable = true;
    })
    (mkIf (cfg.package.pname == "zsh") {
      programs.zsh.enable = true;
    })

    (mkIf cfg.defaultUserShell {
      users.defaultUserShell = cfg.package;
    })
  ]);
}
