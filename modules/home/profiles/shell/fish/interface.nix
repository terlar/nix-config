{ lib, ... }:

{
  options.profiles.shell.fish = {
    enable = lib.mkEnableOption "Fish Profile";
    enableBaseConfig = lib.mkEnableOption "fish base configuration";
    enablePackageCompletionPlugins = lib.mkEnableOption "completion plugins for installed packages";
  };
}
