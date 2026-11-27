{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "ponytail";
  # renovate: datasource=github-tags depName=ponytail packageName=DietrichGebert/ponytail
  version = "5.3.3";
  src = fetchFromGitHub {
    owner = "DietrichGebert";
    repo = "ponytail";
    rev = "v${version}";
    hash = "sha256-CY0EifTY0UVc6/FPGVJjEfYEf/8QLsINQmoYYKZYh98=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    # ponytail.mjs reaches up to ../../hooks and ../../skills relative to its
    # own location, so keep the whole tree intact rather than installing just
    # the plugins/ subdir.
    mkdir -p $out
    cp -r . $out/
    runHook postInstall
  '';

  meta = {
    description = "Lazy senior dev mode for AI agents";
    homepage = "https://github.com/DietrichGebert/ponytail";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
