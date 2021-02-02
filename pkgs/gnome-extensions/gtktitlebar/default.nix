{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-gtktitlebar";
  version = "5.0";

  src = fetchFromGitHub {
    owner = "velitasali";
    repo = "GTKTitleBar";
    rev = version;
    sha256 = "0bg9xz77m6dw6cygnb26slrdhdmr76jmpgp17bcw7rn2rz7ma652";
  };

  uuid = "gtktitlebar@velitasali.github.io";

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/gnome-shell/extensions
    cp -r ${uuid} $out/share/gnome-shell/extensions/.
  '';

  meta = with lib; {
    description =
      "Remove title bars for non-GTK apps with minimal interference with the default workflow";
    homepage = "https://github.com/velitasali/GTKTitleBar";
    license = licenses.gpl3;
    maintainers = with maintainers; [ terlar ];
  };
}
