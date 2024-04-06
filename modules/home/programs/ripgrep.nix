{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.programs.ripgrep;
in
{
  options.programs.ripgrep = {
    enableRipgrepAll = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Whether to enable ripgrep-all.
        Used to search in PDFs, E-Books, Office documents, zip, tar.gz, etc.
      '';
    };
  };

  config = mkIf cfg.enable { home.packages = optional cfg.enableRipgrepAll pkgs.ripgrep-all; };
}
