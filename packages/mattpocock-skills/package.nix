{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "mattpocock-skills";
  # renovate: datasource=github-tags depName=mattpocock-skills packageName=mattpocock/skills
  version = "1.3.2";
  src = fetchFromGitHub {
    owner = "mattpocock";
    repo = "skills";
    rev = "v${version}";
    hash = "sha256-ej0ATi0BWaAx+83dBwgCQxr9J2L2qEwKhUIeIRJ03Go=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    cp -r skills $out
    runHook postInstall
  '';

  meta = {
    description = "Matt Pocock's agent skills";
    homepage = "https://github.com/mattpocock/skills";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
