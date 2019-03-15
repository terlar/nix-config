if builtins.pathExists ./private/data.nix
then import ./private/data.nix
else {
  username = "jdoe";
  name = "John Doe";
  email = "john.doe@example.com";
  keys = {
    gpg = "";
  };
}
