_: prev:

{
  ollama-cuda = prev.ollama-cuda.overrideAttrs rec {
    version = "0.3.5";
    src = prev.fetchFromGitHub {
      owner = "ollama";
      repo = "ollama";
      rev = "v${version}";
      hash = "sha256-2lPOkpZ9AmgDFoIHKi+Im1AwXnTxSY3LLtyui1ep3Dw=";
      fetchSubmodules = true;
    };
  };
}
