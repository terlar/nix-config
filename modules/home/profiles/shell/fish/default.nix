{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.shell.fish;
  packageWithMainProgram = mainProgram: pkg: (pkg.meta.mainProgram or "") == mainProgram;

  anyPackageWithMainProgram =
    mainProgram: builtins.any (packageWithMainProgram mainProgram) config.home.packages;

  packageCompletionPlugins =
    lib.optional (anyPackageWithMainProgram "aws") {
      name = "aws";
      src = pkgs.fetchFromGitHub {
        owner = "terlar";
        repo = "plugin-aws";
        rev = "142c68b2828de93730d00b2b0421242df128e8fc";
        sha256 = "1cgyhjdh29jfly875ly31cjsymi45b3qipydsd9mvb1ws0r6337c";
        # date = 2020-04-22T09:47:07+02:00;
      };
    }
    ++ lib.optional (anyPackageWithMainProgram "gcloud") {
      name = "gcloud";
      src = pkgs.runCommandLocal "gcloud-completions" { } ''
        mkdir -p $out/completions
        echo "complete -c gcloud -f -a '(__fish_argcomplete_complete gcloud)'" > $out/completions/gcloud.fish
        echo "complete -c gsutil -f -a '(__fish_argcomplete_complete gsutil)'" > $out/completions/gsutil.fish
      '';
    };

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
  imports = [ ./interface.nix ];
  config = lib.mkIf cfg.enable {
    programs.fish = {
      enable = true;
      plugins = lib.mkIf cfg.enablePackageCompletionPlugins packageCompletionPlugins;
    };

    xdg = lib.mkIf cfg.enableBaseConfig (
      lib.mkMerge [
        (sourceDirFiles "configFile" "fish/completions" ./completions)
        (sourceDirFiles "configFile" "fish/conf.d" ./conf.d)
        (sourceDirFiles "configFile" "fish/functions" ./functions)
      ]
    );
  };
}
