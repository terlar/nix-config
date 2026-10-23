{
  stdenv,
  lib,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "drduh-gpg-conf";
  version = "20261001";

  src = fetchFromGitHub {
    owner = "drduh";
    repo = "config";
    rev = "b0a2d8153a93bedf3c7e67f9109b3e5970ff1ecc";
    hash = "sha256-18YT9nV5O1cQZbX+SCMw6tWZukjd35uK9yAHB+R1arg=";
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
