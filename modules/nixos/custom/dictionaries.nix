{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) types;
  cfg = config.custom.dictionaries;
in {
  options.custom.dictionaries = {
    enable = lib.mkEnableOption "dictionaries customization";

    useAspell = lib.mkOption {
      type = types.bool;
      default = true;
      description = "Install aspell with dictionaries.";
    };

    useHunspell = lib.mkOption {
      type = types.bool;
      default = true;
      description = "Install hunspell with dictionaries.";
    };

    languages = lib.mkOption {
      type = types.listOf (types.strMatching "[a-z]{2}-[a-z]{2}");
      example = lib.literalExpression ''[ "en-us" ]'';
      description = "List of languages in format of lowercase IETF language tag including country code.";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    (lib.mkIf cfg.useAspell {
      environment.systemPackages = let
        dicts = map (builtins.substring 0 2) cfg.languages;
      in [(pkgs.aspellWithDicts (ps: map (dict: ps."${dict}") dicts))];
    })

    (lib.mkIf cfg.useHunspell {
      environment.systemPackages = let
        dicts = cfg.languages;
      in [(pkgs.hunspellWithDicts (map (dict: pkgs.hunspellDicts."${dict}") dicts))];
    })
  ]);
}
