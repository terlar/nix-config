{
  writeShellApplication,
  gitMinimal,
  nixVersions,
  nixos-rebuild,
}:
writeShellApplication {
  name = "nixos-switch";
  runtimeInputs = [gitMinimal nixVersions.stable nixos-rebuild];
  text = ''
    exec sudo nixos-rebuild switch --flake . "$@"
  '';
}
