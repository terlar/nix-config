{
  writeShellApplication,
  home-manager,
}:
writeShellApplication {
  name = "home-switch";
  runtimeInputs = [home-manager];
  text = ''
    exec home-manager switch -b backup --flake . "$@"
  '';
}
