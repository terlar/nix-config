final: prev:

{
  gnomeExtensions = prev.gnomeExtensions // (with prev.gnome3; {
    paperwm = prev.gnomeExtensions.paperwm.overrideDerivation
      (old:
        let version = "pre-40.0"; in
        {
          inherit version;
          name = "${old.pname}-${version}";
          src = prev.fetchFromGitHub {
            owner = "paperwm";
            repo = "paperwm";
            rev = "e9f714846b9eac8bdd5b33c3d33f1a9d2fbdecd4";
            sha256 = "sha256-gZbS2Xy+CuQfzzZ5IwMahr3VLtyTiLxJTJVawml9sXE=";
          };
        });
  });
}
