{ config, lib, pkgs, ... }:

with lib;

let cfg = config.custom.shell;
in {
  options.custom.shell = {
    enable = mkEnableOption "shell customization";

    package = mkOption {
      type = types.shellPackage;
      default = pkgs.fish;
      defaultText = "pkgs.fish";
      example = literalExample "pkgs.zsh";
      description = "The Shell derivation to use.";
    };

    defaultUserShell = mkOption {
      type = types.bool;
      default = true;
      description = "Set the shell as default user Shell.";
    };

    pager = mkOption {
      type = types.str;
      default = "less";
      description = "The pager to use in Shell.";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment = {
        sessionVariables = {
          SHELL = "${cfg.package}${cfg.package.shellPath}";
          PAGER = cfg.pager;
        };
      };
    }

    (mkIf (cfg.package.pname == "fish") { programs.fish.enable = true; })
    (mkIf (cfg.package.pname == "zsh") { programs.zsh.enable = true; })

    (mkIf cfg.defaultUserShell { users.defaultUserShell = cfg.package; })
  ]);
}
