{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "ponytail";
  version = "5.3.2";
  src = fetchFromGitHub {
    owner = "DietrichGebert";
    repo = "ponytail";
    rev = "v${version}";
    hash = "sha256-IJlhfkdXI6pMZZCZO7XBRg88LBiNfzc5Gnm4ofGybL8=";
  };

  dontBuild = true;

  installPhase = ''
        runHook preInstall

        # ponytail.mjs reaches up to ../../hooks and ../../skills relative to its
        # own location, so keep the whole tree intact rather than installing just
        # the plugins/ subdir.
        mkdir -p $out
        cp -r . $out/

        # Upstream bug: https://github.com/anomalyco/opencode/issues/48122
        # TODO: drop this whole workaround once that lands and a release ships it.
        #
        # OpenCode 2.1.1's plugin loader (packages/plugin/src/host.ts, `resolve()`)
        # probes every configured plugin directory for three optional per-process
        # hook modules via `import(pluginDir + "/<name>")`:
        #   - `server` (background process) falls back to the bare directory
        #     (package.json main) if the file is absent — that fallback is how
        #     ponytail is *meant* to load, per its own install docs.
        #   - `tui` and `rpc` (terminal UI / RPC processes) have no fallback;
        #     ponytail intentionally doesn't need either.
        # The loader's catch requires `error instanceof Error` before even
        # checking the error-code whitelist (ENOENT, MODULE_NOT_FOUND, ...) — but
        # Bun's `ResolveMessage` (thrown for a missing relative-path import) has
        # `instanceof Error === false`, so it never passes that gate and gets
        # rethrown as fatal instead of skipped/falling back. This hits *any*
        # correctly-written V2 plugin installed as a local directory, not just
        # ponytail — it's an opencode bug, not a ponytail compatibility issue. One
        # Die here is fatal to the whole config bootstrap (models/mcp/skills all
        # come back empty) — see the issue above for the exact same failure mode
        # independently confirmed on the server-side plugin-reload path.
        #
        # The fix is NOT "provide any file" — an empty stub at `server.mjs` would
        # satisfy the probe but *shadow* the real fallback-to-package.json-main
        # load, replacing the actual plugin with nothing. `server.mjs` has to
        # re-export the real entrypoint; `tui.mjs`/`rpc.mjs` just need to be
        # validly-shaped no-ops (same id, empty setup) since opencode validates
        # whatever it finds there too.
        cat > $out/.opencode/plugins/server.mjs <<'EOF'
    export { default } from './index.js'
    EOF
        for entrypoint in tui rpc; do
          cat > "$out/.opencode/plugins/$entrypoint.mjs" <<EOF
    export default { id: "ponytail", setup: async () => {} }
    EOF
        done

        runHook postInstall
  '';

  meta = {
    description = "Lazy senior dev mode for AI agents, packaged with an OpenCode 2 plugin-loader compatibility stub";
    homepage = "https://github.com/DietrichGebert/ponytail";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
