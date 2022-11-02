{self, ...}: {
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    imports = [./devshell.nix];
    formatter = pkgs.alejandra;

    checks = {
      nix-format =
        pkgs.runCommand "check-nix-format" {
          nativeBuildInputs = [config.formatter];
        } ''
          cd ${toString self.outPath}
          ${config.formatter.meta.mainProgram or config.formatter.pname} --check .
          mkdir "$out"
        '';

      nix-lint =
        pkgs.runCommand "check-nix-lint" {
          nativeBuildInputs = [pkgs.deadnix pkgs.statix];
        } ''
          cd ${toString self.outPath}
          deadnix --fail .
          statix check .
          mkdir "$out"
        '';
    };
  };
}
