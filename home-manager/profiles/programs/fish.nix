{ dotfiles, lib, pkgs, ... }:

with lib;

let
  sourceDirFiles = attrRoot: destination: target:
    with builtins; {
      ${attrRoot} = foldl' (attrs: file:
        attrs // {
          "${destination}/${file}".source = "${toString target}/${file}";
        }) { } (attrNames (readDir target));
    };
in {
  home.packages = [ pkgs.any-nix-shell ];

  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "aws";
        src = pkgs.fetchFromGitHub {
          owner = "terlar";
          repo = "plugin-aws";
          rev = "142c68b2828de93730d00b2b0421242df128e8fc";
          sha256 = "1cgyhjdh29jfly875ly31cjsymi45b3qipydsd9mvb1ws0r6337c";
          # date = 2020-04-22T09:47:07+02:00;
        };
      }
      {
        name = "kubectl-completions";
        src = pkgs.fetchFromGitHub {
          owner = "evanlucas";
          repo = "fish-kubectl-completions";
          rev = "09c1e7e4803bb5b3a16dd209d3663207579bf6de";
          sha256 = "15k0khzfkms2bh4b4x3fa142wmmn6cfd044mclj3d12fvylr366f";
          # date = 2019-11-08T09:25:50-06:00;
        };
      }
    ];

    interactiveShellInit = ''
      if not set -Uq __fish_universal_config_done
         fish_load_colors
         fish_user_abbreviations
         set -U __fish_universal_config_done 1
      end

      any-nix-shell fish | source

      set -x DIRENV_LOG_FORMAT ""

      if set -q IN_NIX_SHELL
        function __direnv_export_eval
          # Don't trigger within nix-shell
        end
      end
    '';
  };

  xdg = mkMerge [
    (sourceDirFiles "configFile" "fish/completions"
      "${dotfiles}/fish/.config/fish/completions")
    (sourceDirFiles "configFile" "fish/conf.d"
      "${dotfiles}/fish/.config/fish/conf.d")
    (sourceDirFiles "configFile" "fish/functions"
      "${dotfiles}/fish/.config/fish/functions")
  ];
}
