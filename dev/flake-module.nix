{ inputs, ... }:

{
  imports = [ inputs.dev-flake.flakeModule ];

  dev = {
    name = "terlar/nix-config";
    rootSrc = ../.;
  };

  perSystem =
    { pkgs, ... }:
    {
      treefmt = {
        programs.nixfmt = {
          enable = true;
          package = pkgs.nixfmt-rfc-style;
        };
        settings.formatter.fish = {
          command = pkgs.writeShellApplication {
            name = "fish_indent-wrapper";
            runtimeInputs = [
              pkgs.fish
              pkgs.findutils
            ];
            text = ''
              fish_indent --check "$@" 2>&1 | xargs --no-run-if-empty fish_indent --write || true
            '';
          };
          includes = [ "*.fish" ];
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
