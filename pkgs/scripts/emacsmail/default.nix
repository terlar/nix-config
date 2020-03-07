{ stdenv, makeDesktopItem, writeShellScriptBin }:

stdenv.mkDerivation rec {
  name = "emacsmail";

  script = writeShellScriptBin name ''
    exec emacsclient --create-frame --eval "(browse-url-mail \"$@\")"
  '';

  desktopItem = makeDesktopItem {
    inherit name;
    exec = "emacsmail %u";
    icon = "emacs";
    comment = "Mail/News Client";
    desktopName = "Emacs Mail";
    genericName = "Mail/News Client";
    mimeType = "x-scheme-handler/mailto;";
    extraEntries = ''
      StartupWMClass=Emacs
    '';
  };

  dontUnpack = true;

  installPhase = ''
    appDir=$out/share/applications
    mkdir -p $out/bin $appDir
    ln -s ${script}/bin/${name} $out/bin/${name}
    ln -s ${desktopItem}/share/applications/* $appDir/
  '';
}
