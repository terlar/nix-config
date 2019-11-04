{ stdenv, fetchurl }:

let
  linuxPredicate = stdenv.hostPlatform.system == "x86_64-linux";
  darwinPredicate = stdenv.hostPlatform.system == "x86_64-darwin";
  metadata = assert linuxPredicate || darwinPredicate;

  if darwinPredicate then {
    file = "dist_mac.zip";
    sha256 = "1pjk92aajwi2rgrx0fpkbn84yqaya8ffrm2p32xy9d53r5946pac";
  } else {
    file = "dist_linux.tar.gz";
    sha256 = "1l0kpwmi054myri37jfqf4jssfvzdi28xsn3b901pirqhy5z40d3";
  };
in stdenv.mkDerivation rec {
  shortname = "docker-slim";
  name = "${shortname}-${version}";
  version = "1.25.3";

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

    license = licenses.asl20;
    homepage = https://github.com/docker-slim/docker-slim;
    platforms = with platforms; unix;
  };
}
