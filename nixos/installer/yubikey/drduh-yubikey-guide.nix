{
  stdenv,
  lib,
  fetchFromGitHub,
  writeShellApplication,
  glow,
}: let
  version = "20210410";

  guide = stdenv.mkDerivation {
    pname = "drduh-yubikey-guide";
    inherit version;

    src = fetchFromGitHub {
      owner = "drduh";
      repo = "yubikey-guide";
      rev = "dc29279197bbf866b63976395d2c69b1a95ad088";
      hash = "sha256-MMcfiJ31SsrJdPCYn+5MuUxqLJzhY4VeqOS02T9AlL8=";
    };

    dontBuild = true;

    installPhase = ''
      cp $src/README.md $out
    '';

    meta = with lib; {
      description = "Guide to using YubiKey for GPG and SSH";
      homepage = https://github.com/drduh/YubiKey-Guide;
      license = licenses.mit;
    };
  };
in
  writeShellApplication
  {
    name = "drduh-yubikey-guide-reader";
    runtimeInputs = [glow];
    text = ''
      glow --pager ${guide}
    '';
  }
