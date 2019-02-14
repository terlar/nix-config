{ stdenv, fetchurl }:

let
  linuxPredicate = stdenv.hostPlatform.system == "x86_64-linux";
  darwinPredicate = stdenv.hostPlatform.system == "x86_64-darwin";
  metadata = assert linuxPredicate || darwinPredicate;

  if darwinPredicate then {
    file = "dist_mac.zip";
    sha256 = "0xk6qxqzni71glsxafhmsxalcrfbaijaflw1s25ccy1ci6xljcc0";
  } else {
    file = "dist_linux.tar.gz";
    sha256 = "0ff3086cr01hja551lk8x5dbyy18f9gl9fhn2ixwn1vb2zim10sx";
  };
in stdenv.mkDerivation rec {
  shortname = "docker-slim";
  name = "${shortname}-${version}";
  version = "1.23";

  src = fetchurl {
    url = "https://github.com/docker-slim/docker-slim/releases/download/${version}/${metadata.file}";
    sha256 = metadata.sha256;
  };

  buildInputs = [ ];

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p "$out/bin"
    cp "docker-slim" "$out/bin/"
    cp "docker-slim-sensor" "$out/bin/"
  '';

  meta = with stdenv.lib; {
    description = "Minify and Secure Docker containers";

    license = licenses.apache2;
    homepage = https://github.com/docker-slim/docker-slim;
    platforms = with platforms; unix;
  };
}
