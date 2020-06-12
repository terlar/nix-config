{ stdenv, buildPythonPackage, fetchPypi, libX11, libXinerama }:

buildPythonPackage rec {
  pname = "screeninfo";
  version = "0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4293c4eb5f62618971ecdce9a6c41d4878c915d1dd7dde4244b251f118823f95";
  };

  patches = [ ./fix-paths.patch ];

  postPatch = let soext = stdenv.hostPlatform.extensions.sharedLibrary;
  in ''
    substituteInPlace "./screeninfo/screeninfo.py" \
      --replace "@X11@" "${libX11}/lib/libX11${soext}"
    substituteInPlace "./screeninfo/screeninfo.py" \
    --replace "@Xinerama@" "${libXinerama}/lib/libXinerama${soext}"
  '';

  buildInputs = [ libX11 libXinerama ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/rr-/screeninfo";
    description = "Fetch location and size of physical screens";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
