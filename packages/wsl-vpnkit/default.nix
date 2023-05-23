{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  # Runtime
  gvproxy,
  dnsutils,
  gawk,
  iproute2,
  iptables,
  iputils,
  wget,
}: let
  gvproxyCross = gvproxy.overrideAttrs (_: {
    buildPhase = "make cross qemu-wrapper vm";
  });
in
  stdenv.mkDerivation rec {
    pname = "wsl-vpnkit";
    version = "0.4.1";

    src = fetchFromGitHub {
      owner = "sakai135";
      repo = "wsl-vpnkit";
      rev = "v${version}";
      sha256 = "sha256-Igbr3L2W32s4uBepllSz07bkbI3qwAKMZkBrXLqGrGA=";
    };

    nativeBuildInputs = [makeWrapper];

    postPatch = ''
      substituteInPlace wsl-vpnkit \
        --replace "/app/wsl-vm" "${gvproxyCross}/bin/vm" \
        --replace "/app/wsl-gvproxy.exe" "${gvproxyCross}/bin/gvproxy-windows.exe"
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp wsl-vpnkit $out/bin
    '';

    postFixup = ''
      wrapProgram "$out/bin/wsl-vpnkit" \
        --prefix PATH : "${lib.makeBinPath [dnsutils gawk iproute2 iptables iputils wget]}"
    '';
  }
