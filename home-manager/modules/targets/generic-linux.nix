{ config, lib, pkgs, ... }:

with lib;

{
  config = mkIf config.targets.genericLinux.enable {
    programs.fish.shellInit = ''
      set --prepend fish_function_path ${
        if pkgs ? fishPlugins && pkgs.fishPlugins ? foreign-env then
          "${pkgs.fishPlugins.foreign-env}/share/fish/vendor_functions.d"
        else
          "${pkgs.fish-foreign-env}/share/fish-foreign-env/functions"
      }
      fenv source ${pkgs.nix}/etc/profile.d/nix.sh > /dev/null
      set -e fish_function_path[1]
    '';
  };
}
