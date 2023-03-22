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
          rev = "435fb826de8c79dee20de73425642111d0622b20";
          hash = "sha256-qpGcBsFPWPhMubKi4wh7rJ7OBZ33zN16zDJgCF6rde8=";
        };
      });
    };
}
