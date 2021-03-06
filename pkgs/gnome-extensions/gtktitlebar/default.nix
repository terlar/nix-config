{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-gtktitlebar";
  version = "8.0";

  src = fetchFromGitHub {
    owner = "velitasali";
    repo = "gtktitlebar";
    rev = version;
    sha256 = "19hp0hjlzgb67bvbhipf9w4p115i002szvwndm6ym6ch0rdjhh8j";
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
    homepage = "https://github.com/velitasali/gtktitlebar";
    license = licenses.gpl3;
    maintainers = with maintainers; [ terlar ];
  };
}
