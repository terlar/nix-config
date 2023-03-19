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
          rev = "d5e45a3f557a0321fbd45d85c73d668b29fa9035";
          hash = "sha256-gDsVRrysvl8MfG0dNynpd3plXDdzi2/CCYEjN4Vlwa0=";
        };
      });
    };
}
