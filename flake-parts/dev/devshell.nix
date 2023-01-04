{
  config,
  pkgs,
  inputs',
  ...
}: {
  devShells.default = inputs'.devshell.legacyPackages.mkShell {
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
}
