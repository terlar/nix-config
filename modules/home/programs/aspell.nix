{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.aspell;
in
{
  options.programs.aspell = {
    enable = lib.mkEnableOption "aspell";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.aspellWithDicts cfg.dictionaries;
      defaultText = lib.literalExpression "pkgs.aspellWithDicts (_: [])";
      description = "Package providing {command}`aspell` including dictionaries.";
    };

    dictionaries = lib.mkOption {
      default = _: [ ];
      type = lib.hm.types.selectorFunction;
      defaultText = "dicts: []";
      example = lib.literalExpression "dicts: [ dicts.en ]";
      description = ''
        Dictionaries available to Aspell. To get a list of
        available packages run:
        {command}`nix-env -f '<nixpkgs>' -qaP -A aspellDicts`.
      '';
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        home = {
          packages = [ cfg.package ];

          file.".aspell.conf" = {
            enable = !config.xdg.enable;
            text = ''
              dict-dir ${cfg.package}/lib/aspell
            '';
          };
        };
      }

      (lib.mkIf config.xdg.enable {
        home.sessionVariables = {
          ASPELL_CONF = builtins.concatStringsSep "; " [
            "per-conf ${config.xdg.configHome}/aspell/aspell.conf"
            "personal ${config.xdg.configHome}/aspell/en.pws"
            "repl ${config.xdg.configHome}/aspell/en.prepl"
          ];
        };

        xdg.configFile."aspell/aspell.conf".text = ''
          dict-dir ${cfg.package}/lib/aspell
        '';
      })
    ]
  );
}
