{
  stdenv,
  lib,
  fetchFromGitHub,
  writeShellApplication,
  glow,
}:
let
  version = "20210410";

  guide = stdenv.mkDerivation {
    pname = "drduh-yubikey-guide";
    inherit version;

    src = fetchFromGitHub {
      owner = "drduh";
      repo = "yubikey-guide";
      rev = "3912fc0f204cd0c4113bae38e19f68db8cbfa63c";
      hash = "sha256-yOuXY6hEB7V1soqpyYawOL0HqnSHGKGMgNq9BGVqqus=";
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
