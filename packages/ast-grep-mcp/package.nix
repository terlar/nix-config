{
  lib,
  python3Packages,
  fetchFromGitHub,
  ast-grep,
}:

python3Packages.buildPythonApplication {
  pname = "ast-grep-mcp";
  version = "0.1.0-unstable-2026-08-25";

  src = fetchFromGitHub {
    owner = "ast-grep";
    repo = "ast-grep-mcp";
    rev = "149e20d47bb7125fb0c1451feea2f48a98742034";
    hash = "sha256-G2bnsfmzpirQmcllr+wmrvR6n5exe/5OrHnfXDXoyPg=";
  };

  pyproject = true;

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    pydantic
    mcp
    pyyaml
  ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ ast-grep ])
  ];

  # Tests require ast-grep in PATH and test fixtures
  doCheck = false;

  # Upstream pins mcp==2.1.0 exactly; nixpkgs tracks newer compatible releases
  dontCheckRuntimeDeps = true;

  meta = {
    description = "MCP server for ast-grep structural code search";
    homepage = "https://github.com/ast-grep/ast-grep-mcp";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
