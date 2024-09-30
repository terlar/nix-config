{ inputs, ... }:

{
  imports = [ inputs.dev-flake.flakeModule ];

  dev.name = "terlar/nix-config";

  perSystem =
    { pkgs, ... }:
    {
      treefmt = {
        programs.nixfmt = {
          enable = true;
          package = pkgs.nixfmt-rfc-style;
        };
        programs.fish_indent.enable = true;
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
