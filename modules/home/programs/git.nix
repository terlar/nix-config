{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    types
    ;
  cfg = config.programs.git;
in
{
  options.programs.git = {
    ghq = {
      enable = mkEnableOption "" // {
        description = ''
          Whether to enable {command}`ghq` remote repository management.
          See <https://github.com/x-motemen/ghq>.
        '';
      };

      package = mkPackageOption pkgs "ghq" { };

      options = mkOption {
        type =
          with types;
          let
            primitiveType = either str (either bool int);
            sectionType = attrsOf primitiveType;
          in
          attrsOf (either primitiveType sectionType);
        default = { };
        example = {
          root = "~/src";
          "https://git.savannah.gnu.org/git/".vcs = "git";
        };
        description = ''
          Options to configure ghq.
        '';
      };
    };
  };

  config = mkIf cfg.ghq.enable {
    home.packages = [ cfg.ghq.package ];
    programs.git.iniContent.ghq = cfg.ghq.options;
  };
}
