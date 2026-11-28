{ inputs, ... }:

{
  imports = [
    inputs.dev-flake.flakeModule
    inputs.first-ci-kit.flakeModules.default
    inputs.first-ci-kit.flakeModules.git-hooks
    ./ci.nix
  ];

  dev.name = "terlar/nix-config";

  perSystem = {
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
