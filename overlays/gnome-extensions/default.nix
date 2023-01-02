final: prev: {
  gnome40Extensions =
    prev.gnome40Extensions
    // {
      paperwm = prev.gnomeExtensions.paperwm.overrideDerivation (old: let
        version = "40.0";
      in {
        inherit version;
        name = "${old.pname}-${version}";
        src = prev.fetchFromGitHub {
          owner = "paperwm";
          repo = "paperwm";
          rev = "2f5281940d5b7e8e6c80299784f70b1a7f74ecc6";
          hash = "sha256-zZbJpTQbPqxDnVpytdQepz5rYYLALNmXKDypLODx2m8=";
        };
      });
    };

  gnome42Extensions =
    prev.gnome42Extensions
    // (with final.gnome; {
      paperwm = prev.gnomeExtensions.paperwm.overrideDerivation (old: let
        version = "42.0";
      in {
        inherit version;
        name = "${old.pname}-${version}";
        src = prev.fetchFromGitHub {
          owner = "paperwm";
          repo = "paperwm";
          rev = "3b7a4b6c07512d3ba5e1967cda0fbe63c6bb0ae1";
          hash = "sha256-HuqSp6NM9Ye9SyQT+il5Cn4FsSxnT6CAlA/NjwBkajo=";
        };
      });
    });

  gnome43Extensions =
    prev.gnome43Extensions
    // (with final.gnome; {
      paperwm = prev.gnomeExtensions.paperwm.overrideDerivation (old: let
        version = "43.0";
      in {
        inherit version;
        name = "${old.pname}-${version}";
        src = prev.fetchFromGitHub {
          owner = "paperwm";
          repo = "paperwm";
          rev = "f3b486010b9798aa0edce7506403fd6a405ea1f9";
          hash = "sha256-WL4iHkuXgeM8wg7snFaCJh0dYa73iv4itF8d7Mq+ChU=";
        };
      });
    });
}
