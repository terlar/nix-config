final: prev:

{
  gnomeExtensions = prev.gnomeExtensions // (with prev.gnome3; {
    material-shell = prev.gnomeExtensions.material-shell.overrideDerivation (old:
      let version = "40.a"; in
      {
        inherit version;
        name = "${old.pname}-${version}";
        src = prev.fetchFromGitHub {
          owner = "material-shell";
          repo = "material-shell";
          rev = "f44335d07f72f8b3fe984c3390c70d51cca30018";
          sha256 = "sha256-Plzjid2X6C5NM/OWaMk78FKUwNT1taubFBtYw1dNIRw=";
        };
      });

    paperwm = prev.gnomeExtensions.paperwm.overrideDerivation (old:
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
