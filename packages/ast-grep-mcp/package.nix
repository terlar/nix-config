{
  lib,
  python3Packages,
  fetchFromGitHub,
  ast-grep,
}:

python3Packages.buildPythonApplication {
  pname = "ast-grep-mcp";
  version = "0.1.0-unstable-2025-01-15";

  src = fetchFromGitHub {
    owner = "ast-grep";
    repo = "ast-grep-mcp";
    rev = "732c339c3812a44e9111e6c3aefec64894acd58f";
    hash = "sha256-jsKJRr68MsYUy+3siEag+6WAMXHgGug5xkG0Mq3voas=";
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
    "--prefix PATH : ${lib.makeBinPath [ ast-grep ]}"
  ];

  # Tests require ast-grep in PATH and test fixtures
  doCheck = false;

  meta = {
    description = "MCP server for ast-grep structural code search";
    homepage = "https://github.com/ast-grep/ast-grep-mcp";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
