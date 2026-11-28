{ inputs, ... }:

{
  imports = [
    inputs.dev-flake.flakeModule
    inputs.first-ci-kit.flakeModules.default
    inputs.first-ci-kit.flakeModules.git-hooks
    ./ci.nix
  ];

  dev.name = "terlar/nix-config";

  perSystem =
    { config, pkgs, ... }:
    {
      # Run hooks on CI against the changed range, since flake check cannot.
      packages.pre-commit-ci = pkgs.writeShellApplication {
        name = "pre-commit-ci";
        runtimeInputs = [ config.pre-commit.settings.package ];
        runtimeEnv.PRE_COMMIT_CONFIG = config.pre-commit.settings.configFile;
        text = builtins.readFile ./packages/pre-commit-ci/main.bash;
        derivationArgs = {
          nativeBuildInputs = [ pkgs.bats ];
          postCheck = ''
            SUT="$target" bats ${./packages/pre-commit-ci/tests.bats} --tap
          '';
        };
      };

      treefmt.programs = {
        fish_indent.enable = true;
        yamlfmt.enable = true;
      };

      # Generator hook needs nix, unavailable in the flake check sandbox.
      pre-commit.check.enable = false;

      pre-commit.settings.hooks = {
        conform.enable = true;
        first-ci-kit-gen-github-actions = {
          enable = true;
          files = "^dev/ci\\.nix$";
        };
      };

      devshells.default = {
        commands = [
          {
            name = "repl";
            command = ''
              exec nix repl --file "$PRJ_ROOT/dev/repl.nix" "$@"
            '';
            help = "Development REPL";
          }
        ];

        env = [
          {
            name = "NIX_USER_CONF_FILES";
            value = toString ./nix.conf;
          }
        ];
      };
    };
}
