{ extraPackages ? (_: [])
, overrides ? (_: _: {})
, src
, emacs
, emacsPackagesGen
, which
}:

let
  emacsPackages = (emacsPackagesGen emacs).overrideScope' overrides;
  emacsEnv = emacsPackages.emacsWithPackages extraPackages;
in emacsPackages.trivialBuild {
  pname = "emacs-config";
  version = "1";
  inherit src;

  buildInputs = [ emacsEnv ];

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
}
