{ extraPackages ? (_: [])
, overrides ? (_: _: {})
, src
, stdenv
, emacs
, emacsPackagesGen
}:

let
  emacsPackages = (emacsPackagesGen emacs).overrideScope' overrides;
  emacsEnv = emacsPackages.emacsWithPackages extraPackages;
in stdenv.mkDerivation rec {
  pname = "emacs-config";
  version = "1";

  inherit src;
  dontUnpack = true;

  buildInputs = [ emacsEnv ];

  init = emacsPackages.trivialBuild {
    pname = "config-init";
    inherit version src buildInputs;

    preBuild = ''
      find -type l -delete

      mkdir -p .xdg-config
      ln -s $PWD .xdg-config/emacs
      export XDG_CONFIG_HOME="$PWD/.xdg-config"

      export PATH="${emacsEnv}/bin:$PATH"

      emacs --batch -Q \
        *.org \
        -f org-babel-tangle
    '';
  };

  lisp = emacsPackages.trivialBuild {
    pname = "config-lisp";
    src = "${src}/lisp";

    inherit version buildInputs;

    preBuild = ''
      export PATH="${emacsEnv}/bin:$PATH"
    '';
  };

  installPhase = ''
    lispDir=$out/lisp

    install -d $out
    install ${init}/share/emacs/site-lisp/* $out/.
    install -d $lispDir
    install ${lisp}/share/emacs/site-lisp/* $lispDir/.

    cp -r $src/snippets $out/.
    cp -r $src/templates $out/.
  '';
}
