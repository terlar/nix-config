{ lib, pkgs, ... }:

with lib;

let
  sourceDirFiles = attrRoot: destination: target:
    with builtins; {
      ${attrRoot} = foldl'
        (attrs: file: attrs // {
          "${destination}/${file}".source = "${toString target}/${file}";
        })
        {}
        (attrNames (readDir target));
    };
in {
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "aws";
        src = pkgs.fetchFromGitHub {
          owner = "terlar";
          repo = "plugin-aws";
          rev = "be5df956f75a49edcdee7e194aa3c18d91befe6a";
          sha256 = "06zwl5rwvnbr8wz5vnkp3bnvkj2h3annrqj8yfspn0iyni5dk6vb";
          # date = 2020-04-21T14:48:57+02:00;
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
    '';
  };

  xdg = mkMerge [
    (sourceDirFiles "configFile" "fish/completions" <dotfiles/fish/.config/fish/completions>)
    (sourceDirFiles "configFile" "fish/conf.d" <dotfiles/fish/.config/fish/conf.d>)
    (sourceDirFiles "configFile" "fish/functions" <dotfiles/fish/.config/fish/functions>)
  ];
}
