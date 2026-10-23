{
  stdenv,
  lib,
  fetchFromGitHub,
  writeShellApplication,
  glow,
}:
let
  version = "20261022";

  guide = stdenv.mkDerivation {
    pname = "drduh-yubikey-guide";
    inherit version;

    src = fetchFromGitHub {
      owner = "drduh";
      repo = "yubikey-guide";
      rev = "37486bb8cd44ad1c3265aba3a46394c5ff458c48";
      hash = "sha256-Z3hrAJ9pN0/eMrclfJkVByM/jZdluY4dbNNHq/Aix+Y=";
    };

    dontBuild = true;

    installPhase = ''
      cp $src/README.md $out
    '';

    meta = with lib; {
      description = "Guide to using YubiKey for GPG and SSH";
      homepage = "https://github.com/drduh/YubiKey-Guide";
      license = licenses.mit;
    };
  };
in
writeShellApplication {
  name = "drduh-yubikey-guide-reader";
  runtimeInputs = [ glow ];
  text = ''
    glow --pager ${guide}
  '';
}
