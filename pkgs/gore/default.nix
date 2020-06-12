{ stdenv, buildGoPackage, fetchgit, go, makeWrapper }:

buildGoPackage rec {
  pname = "gore";
  version = "0.5.0";

  goPackagePath = "github.com/motemen/gore";
  goDeps = ./deps.nix;

  buildInputs = [ go makeWrapper ];
  # Gore depends on go during runtime.
  allowGoReference = true;

  src = fetchgit {
    url = "https://github.com/motemen/gore";
    rev = "v${version}";
    sha256 = "0kiqf0a2fg6759byk8qbzidc9nx13rajd3f5bx09n19qbgfyflgb";
  };

  postInstall = ''
    wrapProgram "$bin/bin/${pname}" --prefix PATH : "${go}/bin"
  '';

  meta = with stdenv.lib; {
    description =
      "Yet another Go REPL that works nicely. Featured with line editing, code completion, and more.";
    homepage = "https://github.com/motemen/gore";
    license = licenses.mit;
    maintainers = with maintainers; [ terlar ];
  };
}
