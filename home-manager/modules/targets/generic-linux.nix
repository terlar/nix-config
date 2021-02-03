{ config, lib, pkgs, ... }:

with builtins;
with lib;

let
  cfg = config.targets.genericLinux;
  profileDirectory = config.home.profileDirectory;

  openglOpts = {
    options = {
      wrapperPackage = mkOption {
        type = types.nullOr types.package;
        default = null;
        example = literalExample "pkgs.nixGLIntel";
        description = "Package used for OpenGL wrapping.";
      };

      wrapPackages = mkOption {
        type = types.listOf types.package;
        default = [ ];
        example = literalExample ''
          with pkgs; [
            alacritty
            kitty
          ]
        '';

        description = ''
          List of packages that needs to be wrapped with a OpenGL wrapper.
        '';
      };
    };
  };
in {
  options.targets.genericLinux = {
    opengl = mkOption {
      type = types.nullOr (types.submodule openglOpts);
      default = null;
      example = literalExample ''
        {
          wrapperPackage = pkgs.nixGLIntel;
          wrapPackages = [ pkgs.kitty ];
        }
      '';
      description = ''
        OpenGL compatibility configuration.
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      systemd.user.sessionVariables = let
        profiles = [
          "\${NIX_STATE_DIR:-/nix/var/nix}/profiles/default"
          profileDirectory
        ];
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
    }
    (mkIf (cfg.opengl != null && cfg.opengl.wrapperPackage != null
      && cfg.opengl.wrapPackages != [ ]) {
        home.packages = [ cfg.opengl.wrapperPackage ];

        nixpkgs.config.packageOverrides = let
          packageNames = map getName cfg.opengl.wrapPackages;

          getBinFiles = pkg:
            pipe "${getBin pkg}/bin" [
              readDir
              attrNames
              (filter (n: match "^\\..*" n == null))
            ];

          wrapperBin = pipe cfg.opengl.wrapperPackage [
            getBinFiles
            (filter (n: n == (getName cfg.opengl.wrapperPackage)))
            head
          ];

          wrapBinFiles = pkg:
            let
              binFiles = getBinFiles pkg;
              wrapBin = name:
                pkgs.writeShellScriptBin name ''
                  exec ${wrapperBin} ${pkg}/bin/${name} "$@"
                '';
            in pkgs.symlinkJoin {
              name = "${pkg.name}-nixgl";
              paths = (map wrapBin binFiles) ++ [ pkg ];
            };
        in genAttrs packageNames (name: wrapBinFiles pkgs.${name});
      })
  ]);
}
