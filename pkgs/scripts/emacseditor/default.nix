{ stdenv, makeDesktopItem, writeShellScriptBin }:

stdenv.mkDerivation rec {
  name = "emacseditor";

  script = writeShellScriptBin name ''
    if [ -z "$1" ]; then
      exec emacsclient --create-frame --alternate-editor emacs
    else
      exec emacsclient --alternate-editor emacs "$@"
    fi
  '';

  desktopItem = makeDesktopItem {
    inherit name;
    exec = "emacseditor %F";
    icon = "emacs";
    comment = "Edit text";
    desktopName = "Emacs";
    genericName = "Text Editor";
    categories = "Development;TextEditor;";
    mimeType = "text/english;text/plain;text/x-makefile;text/x-c++hdr;text/x-c++src;text/x-chdr;text/x-csrc;text/x-java;text/x-moc;text/x-pascal;text/x-tcl;text/x-tex;application/x-shellscript;text/x-c;text/x-c++;application/pdf;";
    extraEntries = ''
      StartupWMClass=Emacs
      Keywords=Text;Editor;
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
