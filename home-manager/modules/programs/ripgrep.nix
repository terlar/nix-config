{ config, lib, pkgs, ... }:

with lib;
let cfg = config.programs.ripgrep;
in
{
  options.programs.ripgrep = {
    enable = mkEnableOption "ripgrep";

    configPath = mkOption {
      type = types.path;
      default = "${config.xdg.configHome}/ripgrep/config";
      defaultText = "$XDG_DATA_HOME/ripgrep/config";
      apply = toString; # Prevent copies to Nix store.
      description = ''
        The path where ripgrep will look for its configuration.
      '';
    };

    enableRipgrepAll = mkOption {
      default = true;
      type = types.bool;
      description = ''
        Whether to enable ripgrep-all.
        Used to search in PDFs, E-Books, Office documents, zip, tar.gz, etc.
      '';
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Extra configuration lines to add to ripgrep configuration.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.ripgrep ]
      ++ optional cfg.enableRipgrepAll pkgs.ripgrep-all;

    home.sessionVariables.RIPGREP_CONFIG_PATH = cfg.configPath;

    home.file.${cfg.configPath}.text = ''
      ${cfg.extraConfig}
    '';
  };
}
