{ stdenv, buildGoPackage, fetchurl }:

buildGoPackage rec {
  name = "saw-${version}";
  version = "0.2.2";

  goPackagePath = "github.com/TylerBrock/saw";

  src = fetchurl {
    url = "https://github.com/TylerBrock/saw/archive/v${version}.tar.gz";
    sha256 = "1ksbkqhcjxkd2hnfa4x73sv6f0pdpc10vzw62abmwwbay8j7plij";
  };

  goDeps = ./deps.nix;

  meta = {
    description = "Fast, multi-purpose tool for AWS CloudWatch Logs.";
    homepage = https://github.com/TylerBrock/saw;
    maintainers = [ stdenv.maintainers.terlar];
    license = stdenv.lib.licenses.mit;
  };
}
