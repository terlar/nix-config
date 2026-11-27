{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "diagram-design";
  version = "0-unstable-2026-11-26";
  src = fetchFromGitHub {
    owner = "cathrynlavery";
    repo = "diagram-design";
    # renovate: datasource=git-refs depName=diagram-design packageName=https://github.com/cathrynlavery/diagram-design branch=main
    rev = "795eec47fd376e5dda0b9e056a49520060cd2f13";
    hash = "sha256-C0L3iyMYOkTk39yPslIkwkUTCKx8Y7KM89oitHGp2PA=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    cp -r skills $out
    runHook postInstall
  '';

  meta = {
    description = "Agent skill for designing diagrams";
    homepage = "https://github.com/cathrynlavery/diagram-design";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
