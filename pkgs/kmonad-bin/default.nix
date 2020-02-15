{ stdenv, fetchurl }:

let
  version = "0.3.0";

  srcs = {
    x86_64-linux = fetchurl {
      url = "https://github.com/david-janssen/kmonad/releases/download/${version}/kmonad-${version}-linux";
      sha256 = "02zwp841g5slvqvwha5q1ynww34ayfk1cfb1y32f1zzw7n1b0ia5";
    };
  };
in stdenv.mkDerivation rec {
  pname = "kmonad-bin";
  inherit version;

  src = srcs.${stdenv.hostPlatform.system} or (throw "unsupported system: ${stdenv.hostPlatform.system}");

  buildCommand = ''
    mkdir -p $out/bin
    install -Dm755 $src "$out"/bin/kmonad
  '';

  meta = with stdenv.lib; {
    description = "An advanced keyboard manager";
    homepage = "https://github.com/david-janssen/kmonad";
    platforms = attrNames srcs;
    maintainers = with maintainers; [ terlar ];
    license = licenses.mit;
  };
}
