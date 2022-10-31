{
  writeShellApplication,
  cachix,
}:
writeShellApplication {
  name = "use-caches";
  runtimeInputs = [cachix];
  text = ''
    cachix use -O . nix-community
    cachix use -O . terlar
  '';
}
