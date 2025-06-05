{ config, lib, ... }:

let
  inherit (lib)
    literalExpression
    mkOption
    types
    ;

  cfg = config.programs.qutebrowser;
in
{
  options.programs.qutebrowser = {
    dictionaries = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = ''
        Chromium compatible hunspell dictionaries to install and configure. See `pkgs.hunspellDictsChromium`.
      '';
      example = literalExpression ''
        [
          pkgs.hunspellDictsChromium.en-us
        ]
      '';
    };
  };

  config = lib.mkIf (cfg.dictionaries != [ ]) {
    xdg.dataFile = lib.pipe cfg.dictionaries [
      (map (source: {
        name = "qutebrowser/qtwebengine_dictionaries/${source.dictFileName}";
        value = { inherit source; };
      }))
      lib.listToAttrs
    ];
  };
}
