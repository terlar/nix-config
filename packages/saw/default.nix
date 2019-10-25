{ stdenv, buildGoPackage, fetchgit }:

buildGoPackage rec {
  name = "saw-${version}";
  version = "0.2.2";

  goPackagePath = "github.com/TylerBrock/saw";

  src = fetchgit {
    url = https://github.com/TylerBrock/saw;
    rev = "v${version}";
    sha256 = "06c5svy6iq15b0dzsprw460j23p6ma26w0jp39xcn5nb1s1girq8";
  };

  goDeps = ./deps.nix;

  meta = {
    description = "Fast, multi-purpose tool for AWS CloudWatch Logs.";
    homepage = https://github.com/TylerBrock/saw;
    maintainers = [ stdenv.maintainers.terlar];
    license = stdenv.lib.licenses.mit;
  };
}
