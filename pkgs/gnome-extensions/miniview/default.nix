{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-miniview";
  version = "1";

  src = fetchFromGitHub {
    owner = "iamlemec";
    repo = "miniview";
    rev = "860186aa99a7ffb55cfd3d5b2c1719633a14af53";
    sha256 = "0ikg16bhbd357vpm4k9wgv3ygjpvbfysf2rr7p0h0mqg54fhpl7b";
    # date = 2020-06-04T23:27:28-04:00;
  };

  uuid = "miniview@thesecretaryofwar.com";

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp -r . $out/share/gnome-shell/extensions/${uuid}
  '';

  meta = with lib; {
    description = "Shows a preview window overlay (like picture-in-picture on a TV)";
    homepage = "https://github.com/iamlemec/miniview";
    license = licenses.gpl3;
    maintainers = with maintainers; [ terlar ];
  };
}
