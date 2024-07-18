{ config, lib, ... }:

let
  inherit (lib) mkDefault mkIf mkMerge;

  cfg = config.profiles.user.terje.shell.fish;

  sourceDirFiles = attrRoot: destination: target: {
    ${attrRoot} = lib.pipe target [
      builtins.readDir
      builtins.attrNames
      (builtins.foldl' (
        attrs: file: attrs // { "${destination}/${file}".source = "${toString target}/${file}"; }
      ) { })
    ];
  };
in
{
  options.profiles.user.terje.shell.fish = {
    enable = lib.mkEnableOption "Fish shell profile for Terje";
    enableBaseConfig = lib.mkEnableOption "Fish base configuration for Terje";
  };

  config = mkIf cfg.enable {
    profiles.shell.fish.enablePackageCompletionPlugins = mkDefault true;
    xdg = mkIf cfg.enableBaseConfig (mkMerge [
      (sourceDirFiles "configFile" "fish/completions" ./completions)
      (sourceDirFiles "configFile" "fish/conf.d" ./conf.d)
      (sourceDirFiles "configFile" "fish/functions" ./functions)
    ]);
  };
}
