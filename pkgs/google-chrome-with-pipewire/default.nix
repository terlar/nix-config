{ makeWrapper, stdenv, google-chrome, pipewire }:

with builtins;

let
  binName = head (filter (n: match "^\\..*" n == null)
    (attrNames (readDir "${google-chrome}/bin")));
  pnameFromName = p: replaceStrings [ "-${p.version}" ] [ "" ] p.name;
in stdenv.mkDerivation {
  pname = "${pnameFromName google-chrome}-with-pipewire";
  inherit (google-chrome) version;

  buildInputs = [ makeWrapper ];
  buildCommand = ''
    makeWrapper \
      "${google-chrome}/bin/${binName}" \
      $out/bin/${binName} \
      --prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath [ pipewire ]} \
      --add-flags '--enable-features=WebRTCPipeWireCapturer'
  '';
}
