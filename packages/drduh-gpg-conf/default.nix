{
  stdenv,
  lib,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "drduh-gpg-conf";
  version = "20210215";

  src = fetchFromGitHub {
    owner = "drduh";
    repo = "config";
    rev = "6e294925af6c289e13cc5237ffe895331b4389ec";
    hash = "sha256-gh/tvPiAA1iuvYUBTh6zji2cUKvvMeM5jL2oqV0Xzb8=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir $out
    cp $src/gpg.conf $out/gpg.conf
  '';

  meta = with lib; {
    description = "drduh's gpg.conf";
    homepage = "https://github.com/drduh/config";
    license = licenses.mit;
  };
}
