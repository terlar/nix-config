{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-miniview";
  version = "20210626.2102";

  src = fetchFromGitHub {
    owner = "iamlemec";
    repo = "miniview";
    rev = "e41beb9e74193d5174c5fd52a7e52199027a998a";
    sha256 = "1qh4n5aakwaw17fkcjn10lm2v7ckfm2p4r7jc4bm0bfsmibpws3b";
    # date = 2021-06-26T21:02:05-04:00;
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
