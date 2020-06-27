{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-invert-window";
  version = "5";

  src = fetchFromGitHub {
    owner = "maiself";
    repo = "gnome-shell-extension-invert-color";
    rev = "0e70aae1671c4fe4a5b42392fc588e1e5cd6f259";
    sha256 = "12z9f1kc5376713chd21fj96c1gr9bil56fxjbqkql2v1qx2fqw3";
    # date = 2020-03-25T00:19:16-04:00;
  };

  uuid = "invert-window@maiself";

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp -r . $out/share/gnome-shell/extensions/${uuid}
  '';

  meta = with stdenv.lib; {
    description = "Inverts the color of individual windows.";
    homepage = "https://github.com/maiself/gnome-shell-extension-invert-color";
    license = licenses.mit;
    maintainers = with maintainers; [ terlar ];
  };
}
