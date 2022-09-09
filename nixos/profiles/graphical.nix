{
  config,
  pkgs,
  ...
}: {
  imports = [./fonts.nix];

  # Graphical boot process.
  boot.plymouth.enable = true;
}
