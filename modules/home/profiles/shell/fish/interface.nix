{ lib, ... }:

{
  options.profiles.shell.fish = {
    enable = lib.mkEnableOption "fish profile";
    enablePackageCompletionPlugins = lib.mkEnableOption "completion plugins for installed packages";
  };
}
