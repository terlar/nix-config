{
  description = "Development environment";

  inputs = {
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    dev-flake = {
      url = "github:terlar/dev-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        call-flake.url = "github:divnix/call-flake/a9bc85f5bd939734655327a824b4e7ceb4ccaba9";
      };
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";

    # Compatibility
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      imports = [ inputs.dev-flake.flakeModule ];

      dev = {
        name = "terlar/nix-config";
        rootSrc = ../.;
      };

      perSystem =
        { pkgs, ... }:
        {
          treefmt.programs.nixfmt = {
            enable = true;
            package = pkgs.nixfmt-rfc-style;
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
    };
}
