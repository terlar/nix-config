{
  perSystem = {pkgs, ...}: {
    imports = [./devshell.nix];
    formatter = pkgs.alejandra;
  };
}
