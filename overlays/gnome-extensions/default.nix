_final: prev: {
  gnomeExtensions =
    prev.gnomeExtensions
    // {
      paperwm = prev.gnomeExtensions.paperwm.overrideDerivation (old: let
        version = "unstable-2023-03-11";
      in {
        inherit version;
        name = "${old.pname}-${version}";
        src = prev.fetchFromGitHub {
          owner = "paperwm";
          repo = "paperwm";
          rev = "7fa25a6072a8ccd51ecbf154d030f23d2ed98d4e";
          hash = "sha256-BkP88+5QGFEbkiPfnE0Eu9IUkZtB4QyepWB7m/t5TFE=";
        };
      });
    };
}
