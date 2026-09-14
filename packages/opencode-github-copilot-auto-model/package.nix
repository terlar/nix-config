{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  bun,
}:

stdenvNoCC.mkDerivation rec {
  pname = "opencode-github-copilot-auto-model";
  version = "0.2.0";
  src = fetchFromGitHub {
    owner = "m0wer";
    repo = "opencode-github-copilot-auto-model";
    rev = "v${version}";
    hash = "sha256-Jx9Qijh2u8cO2dXuXPjuec3pjXnnLZxvmkP/ES+L4Gk=";
  };
  nativeBuildInputs = [ bun ];
  buildPhase = ''
    runHook preBuild
    bun build ./src/index.ts \
      --outfile dist/index.js \
      --target node \
      --format esm \
      --external @opencode-ai/plugin \
      --external @opencode-ai/sdk
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/opencode-github-copilot-auto-model
    cp -r package.json dist $out/lib/opencode-github-copilot-auto-model/
    runHook postInstall
  '';
  meta = {
    description = "OpenCode plugin exposing GitHub Copilot's auto model routing";
    homepage = "https://github.com/m0wer/opencode-github-copilot-auto-model";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
