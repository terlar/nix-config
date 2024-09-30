{ inputs, ... }:

{
  imports = [ inputs.dev-flake.flakeModule ];

  dev.name = "terlar/nix-config";

  perSystem =
    { config, pkgs, ... }:
    {
      formatter = config.treefmt.programs.nixfmt.package;

      treefmt.programs = {
        nixfmt = {
          enable = true;
          package = pkgs.nixfmt-rfc-style;
        };

        fish_indent.enable = true;
        yamlfmt.enable = true;
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
