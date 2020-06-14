{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-switcher";
  version = "28";

  src = fetchFromGitHub {
    owner = "daniellandau";
    repo = "switcher";
    rev = "84b83b5ae3d73932bb61bc3873c0cd5578fb7d44";
    sha256 = "1gahpvbill51nrb9qrwxdwnaxm8mis6a1lvxkl2i7ad8rdxqvvmr";
    # date = 2020-04-07T22:53:59+03:00;
  };

  uuid = "switcher@landau.fi";

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp -r . $out/share/gnome-shell/extensions/${uuid}
  '';

  meta = with stdenv.lib; {
    description = "Gnome Shell extension to switch windows quickly by typing";
    homepage = "https://github.com/daniellandau/switcher";
    license = licenses.gpl3;
    maintainers = with maintainers; [ terlar ];
  };
}
