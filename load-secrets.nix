if builtins.pathExists ./private/secrets.nix then import ./private/secrets.nix else {
  fullName = "";
  email = "";
  gpgKey = "";
}
