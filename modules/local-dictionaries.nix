{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.local.dictionaries;
in {
  options.local.dictionaries = {
    enable = mkEnableOption "Enables dictionaries.";

    useAspell = mkOption {
      type = types.bool;
      default = true;
      description = "Install aspell with dictionaries.";
    };

    useHunspell = mkOption {
      type = types.bool;
      default = true;
      description = "Install hunspell with dictionaries.";
    };

    languages = mkOption {
      type = types.listOf (types.strMatching "[a-z]{2}-[a-z]{2}");
      example = literalExample ''[ "en-us" ]'';
      description = "List of languages in format of lowercase IETF language tag including country code.";
     };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.useAspell {
      environment.systemPackages = let
        dicts = map (substring 0 2) cfg.languages;
      in with pkgs; [
        (aspellWithDicts (ps: map (dict: ps."${dict}") dicts))
      ];
    })

    (mkIf cfg.useHunspell {
      environment.systemPackages = let
        dicts = cfg.languages;
      in with pkgs; [
        (hunspellWithDicts(map (dict: hunspellDicts."${dict}") dicts))
      ];
    })
  ]);
}
