{ stdenv, buildGoPackage, fetchgit }:

buildGoPackage rec {
  name = "gore-${version}";
  version = "0.4.1";

  goPackagePath = "github.com/motemen/gore";

  src = fetchgit {
    url = https://github.com/motemen/gore;
    rev = "v${version}";
    sha256 = "06yvklvx5vhjprrgi66rjy3x6kgvivrcqg3nv1alr97jnsf427vs";
  };

  goDeps = ./deps.nix;

  meta = {
    description = "Yet another Go REPL that works nicely. Featured with line editing, code completion, and more.";
    homepage = https://github.com/motemen/gore;
    maintainers = [ stdenv.maintainers.terlar];
    license = stdenv.lib.licenses.mit;
  };
}
