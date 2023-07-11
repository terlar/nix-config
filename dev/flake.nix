{
  description = "Development environment";

  inputs = {
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    dev-flake = {
      url = "github:terlar/dev-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Compatibility
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];

      imports = [inputs.dev-flake.flakeModule];

      dev = {
        name = "terlar/nix-config";
        rootSrc = ../.;
      };

      perSystem = {rootFlake', ...}: {
        inherit (rootFlake') formatter;
        treefmt.programs.alejandra.enable = true;

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
              value = toString ../nix.conf;
            }
          ];
        };
      };
    };
}
