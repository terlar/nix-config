self: pkgs:

{
  emacs = self.emacs26;

  emacsPackagesNg = self.emacs26PackagesNg;
  emacs26PackagesNg = (self.emacsPackagesNgGen self.emacs26);
  emacsHEADPackagesNg = (self.emacsPackagesNgGen self.emacsHEAD);

  emacs26 = with pkgs; stdenv.lib.overrideDerivation
    (pkgs.emacs26.override { srcRepo = true; }) (attrs: rec {
      name = "emacs-${version}${versionModifier}";
      version = "26.1";
      versionModifier = "";

      buildInputs = emacs26.buildInputs ++
        [ git libpng.dev libjpeg.dev libungif libtiff.dev librsvg.dev
          imagemagick.dev ];

      patches = [];

      src = fetchgit {
        url = https://git.savannah.gnu.org/git/emacs.git;
        rev = "7851ae8b443c62a41ea4f4440512aa56cc87b9b7";
        sha256 = "05jrp3nhjrwrsipphzman7x9rwbzcf2ik17rp1h1ghq1q9ryx73x";
        # date = 2018-11-19T07:33:53-08:00;
      };

      postPatch = ''
        rm -rf .git
      '';
    });

  emacsHEAD = with pkgs; stdenv.lib.overrideDerivation
    (pkgs.emacs26.override { srcRepo = true; }) (attrs: rec {
      name = "emacs-${version}${versionModifier}";
      version = "27.0";
      versionModifier = ".50";

      buildInputs = emacs26.buildInputs ++
        [ git libpng.dev libjpeg.dev libungif libtiff.dev librsvg.dev
          imagemagick.dev ];

      patches = [];

      configureFlags = [ "--with-modules" ] ++
        [ "--with-ns" "--disable-ns-self-contained"
          "--enable-checking=yes,glyphs"
          "--enable-check-lisp-object-type" ];

      src = ~/src/git.sv.gnu.org/emacs;

      postPatch = ''
        rm -rf .git
        sh autogen.sh
      '';
    });
}
