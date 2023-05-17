_final: prev: {
  gnomeExtensions =
    prev.gnomeExtensions
    // {
      paperwm = prev.gnomeExtensions.paperwm.overrideDerivation (old: let
        version = "unstable-2023-05-17";
      in {
        inherit version;
        name = "${old.pname}-${version}";
        src = prev.fetchFromGitHub {
          owner = "paperwm";
          repo = "paperwm";
          rev = "477e87a4f04a01ad05245852c0cf645fd19bec0c";
          hash = "sha256-0IWPuKwkjEnogJSwFaJgbA6hFq6lIAJwi7OkfIq2mwg=";
        };
      });
    };
}
