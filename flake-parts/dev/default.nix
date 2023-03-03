{inputs, ...}: {
  imports = [
    inputs.devshell.flakeModule
    inputs.pre-commit-hooks.flakeModule
    inputs.treefmt.flakeModule
  ];

  perSystem = {
    config,
    pkgs,
    ...
  }: {
    formatter = pkgs.alejandra;
    treefmt.programs.alejandra.enable = true;

    treefmt = {
      flakeFormatter = false;
      projectRootFile = "flake.nix";
    };

    pre-commit = {
      check.enable = true;
      settings.hooks = {
        deadnix.enable = true;
        statix.enable = true;
        treefmt.enable = true;
      };
    };

    devshell.shells.default = {
      name = "terlar/nix-config";
      devshell.startup.pre-commit-install.text = config.pre-commit.installationScript;

      packages = [
        pkgs.git
        pkgs.nixVersions.stable
      ];

      commands = [
        {
          name = "repl";
          command = ''
            exec nix repl repl.nix "$@"
          '';
          category = "development";
          help = "Development REPL";
        }
      ];

      env = [
        {
          name = "NIX_USER_CONF_FILES";
          value = toString ../../nix.conf;
        }
      ];
    };
  };
}
