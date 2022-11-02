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
    rev = "2703f5992be264e993a46802169a76e7211d9ad0";
    hash = "sha256-ui3VylKFd68sV/PligG+7S86Xi+TGYOoeekBDFvBwJY=";
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
