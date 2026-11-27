{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "superpowers";
  # renovate: datasource=github-tags depName=superpowers packageName=obra/superpowers
  version = "7.0.1";
  src = fetchFromGitHub {
    owner = "obra";
    repo = "superpowers";
    rev = "v${version}";
    hash = "sha256-9+69YEdjdaDu5sWTyAbufSVcZgGD7h6wAq4nUVY2syE=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    cp -r skills $out
    runHook postInstall
  '';

  meta = {
    description = "Agent skills library for structured development workflows";
    homepage = "https://github.com/obra/superpowers";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
