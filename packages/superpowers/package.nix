{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "superpowers";
  # renovate: datasource=github-tags depName=superpowers packageName=obra/superpowers
  version = "7.0.2";
  src = fetchFromGitHub {
    owner = "obra";
    repo = "superpowers";
    rev = "v${version}";
    hash = "sha256-rP5YsyGuPd9YSW/Fj3aukrq1bLuV+nwwQMK4JaZQgkI=";
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
