{ config, lib, pkgs, ... }:

with builtins;
with lib;

let
  cfg = config.targets.genericLinux;
  profileDirectory = config.home.profileDirectory;
in {
  config = mkIf cfg.enable (mkMerge [{
    systemd.user.sessionVariables = let
      profiles =
        [ "\${NIX_STATE_DIR:-/nix/var/nix}/profiles/default" profileDirectory ];
      dataDirs = concatStringsSep ":"
        (map (profile: "${profile}/share") profiles ++ cfg.extraXdgDataDirs);
    in { XDG_DATA_DIRS = "${dataDirs}\${XDG_DATA_DIRS:+:}$XDG_DATA_DIRS"; };

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
  }]);
}
