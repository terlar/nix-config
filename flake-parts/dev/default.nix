{inputs, ...}: {
  imports = [inputs.pre-commit-hooks.flakeModule];

  perSystem = {pkgs, ...}: {
    imports = [./devshell.nix];

    formatter = pkgs.alejandra;

    pre-commit = {
      check.enable = true;
      settings.hooks = {
        alejandra.enable = true;
        deadnix.enable = true;
        statix.enable = true;
      };
    };
  };
}
