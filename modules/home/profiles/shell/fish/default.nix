{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;

  cfg = config.profiles.shell.fish;

  packageWithMainProgram = mainProgram: pkg: (pkg.meta.mainProgram or "") == mainProgram;

  anyPackageWithMainProgram =
    mainProgram: builtins.any (packageWithMainProgram mainProgram) config.home.packages;

  packageCompletionPlugins = lib.optional (anyPackageWithMainProgram "aws") {
    name = "aws";
    src = pkgs.fetchFromGitHub {
      owner = "terlar";
      repo = "plugin-aws";
      rev = "142c68b2828de93730d00b2b0421242df128e8fc";
      sha256 = "1cgyhjdh29jfly875ly31cjsymi45b3qipydsd9mvb1ws0r6337c";
      # date = 2020-04-22T09:47:07+02:00;
    };
  };
in
{
  imports = [ ./interface.nix ];

  config = mkIf cfg.enable {
    programs.fish = {
      enable = true;
      plugins = mkIf cfg.enablePackageCompletionPlugins packageCompletionPlugins;
    };
  };
}
