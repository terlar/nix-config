self: pkgs:

let
  overrides = self: super: super.melpaPackages // {
    kubernetes = super.kubernetes.overrideAttrs(attrs: {
      buildInputs = attrs.buildInputs ++ [ pkgs.git ];
    });

    all-the-icons = super.all-the-icons.overrideAttrs(attrs: {
      patches = [ ./emacs/patches/all-the-icons.patch ];
    });
    all-the-icons-dired = super.all-the-icons-dired.overrideAttrs(attrs: {
      patches = [ ./emacs/patches/all-the-icons-dired.patch ];
    });
    editorconfig = super.editorconfig.overrideAttrs(attrs: {
      patches = [ ./emacs/patches/editorconfig.patch ];
    });
    rspec-mode = super.rspec-mode.overrideAttrs(attrs: {
      patches = [ ./emacs/patches/rspec-mode.patch ];
    });

    eglot = super.eglot.overrideAttrs(attrs: {
      version = "20181204";
      src = pkgs.fetchFromGitHub {
        owner  = "joaotavora";
        repo   = "eglot";
        rev    = "6b0b1b75948abe1f42f4f676c1379adc4372ec9b";
        sha256 = "161g3a8f6aq4r6plwhbbq041wfbwx7prsx3khp2bsdc883c8lycw";
        # date = 2018-12-07T23:23:28+00:00;
      };
    });

    ivy = super.ivy.overrideAttrs(attrs: {
      version = "20181129";
      src = pkgs.fetchFromGitHub {
        owner  = "abo-abo";
        repo   = "swiper";
        rev    = "86635fb8268c07b9fb534357e8e0940c23edeef7";
        sha256 = "1bx091lh9kyqpw4dpgrlars6ziyl37vvva6ycw5w65a6f2bb57ia";
        # date = 2018-11-29T22:05:38+01:00;
      };
    });

    magit = super.magit.overrideAttrs(attrs: {
      version = "20181204";
      src = pkgs.fetchFromGitHub {
        owner  = "magit";
        repo   = "magit";
        rev    = "bf226698b769ba4cc12d3dad12d15a03319d36a5";
        sha256 = "0bdqkx5hckqgq8p0maflfgiz3gwj4y6dhwmfr2xyxha8b8ih6b11";
        # date = 2018-12-04T21:04:25+01:00;
      };
    });

    nix-mode = super.nix-mode.overrideAttrs(attrs: {
      version = "20181120";
      src = pkgs.fetchFromGitHub {
        owner  = "nixos";
        repo   = "nix-mode";
        rev    = "90ac0a74b205f11dc456676b6dbefc5072e7eb6c";
        sha256 = "00v70v64icsi5iwrimdb311rvlcpazwg22hg12x7l6m87c949krf";
        # date = 2018-11-20T16:53:03-06:00;
      };
    });

    org-variable-pitch = super.org-variable-pitch.overrideAttrs(attrs: {
      version = "20181206";
      src = pkgs.fetchFromGitHub {
        owner  = "cadadr";
        repo   = "elisp";
        rev    = "b41b899da9dec75cbf9f5fe8858d12c271391073";
        sha256 = "1y8z27v0y2cmg2vjw5lsd3fs4rcrj0v6jcn5c439c0qlg8missp7";
        # date = 2018-12-06T18:02:51+03:00;
      };
    });

    org-pretty-table = self.melpaBuild rec {
      pname   = "org-pretty-table";
      version = "20131129";
      src = pkgs.fetchFromGitHub {
        owner  = "fuco1";
        repo   = "org-pretty-table";
        rev    = "0dca6f3156dd1eb0a42f08ac2ad89259637a16b5";
        sha256 = "09avbl1mmgs3b1ya0rvv9kswq2k7d133zgr18cazl3jkpvh35lxg";
        # date = 2013-11-29T16:10:09+01:00;
      };
      recipe = pkgs.writeText "recipe" ''
        (org-pretty-table :repo "fuco1/org-pretty-table" :fetcher github)
      '';

      meta = {
        description = "Replace org-table characters with box-drawing unicode glyphs";
        longDescription = ''
          This replaces the characters - | and + in `org-mode' tables with
          appropriate unicode box-drawing glyphs, see
          http://en.wikipedia.org/wiki/Box-drawing_character
        '';
      };
    };

    rotate-text = self.melpaBuild rec {
      pname   = "rotate-text";
      version = "20090413";
      src = pkgs.fetchFromGitHub {
        owner  = "nschum";
        repo   = "rotate-text.el";
        rev    = "74c456f91bfefb19dfcd33dbb3bd8574d1f185c6";
        sha256 = "1cgxv4aibkvv6lnssynn0438a615fz3zq8hg9sb0lhfgsr99pxln";
        # date = 2009-04-13T22:36:18+02:00;
      };
      recipe = pkgs.writeText "recipe" ''
        (rotate-text :repo "nschum/rotate-text.el" :fetcher github)
      '';

      meta = {
        description = "Cycle through words, symbols and patterns";
        longDescription = ''
          rotate-text allows you cycle through commonly interchanged text with a single
          keystroke.  For example, you can toggle between "frame-width" and
          "frame-height", between "public", "protected" and "private" and between
          "variable1", "variable2" through "variableN".
        '';
      };
    };

    source-peek = self.melpaBuild rec {
      pname   = "source-peek";
      version = "20170424";
      src = pkgs.fetchFromGitHub {
        owner  = "iqbalansari";
        repo   = "emacs-source-peek";
        rev    = "fa94ed1def1e44f3c3999d355599d1dd9bc44dab";
        sha256 = "14ai66c7j2k04a0vav92ybaikcc8cng5i5vy0iwpg7b2cws8a2zg";
        # date = 2017-04-24T03:47:10+05:30;
      };
      recipe = pkgs.writeText "recipe" ''
        (source-peek :repo "iqbalansari/emacs-source-peek" :fetcher github)
      '';

      meta = {
        description = "Display function definitions inline";
        longDescription = ''
          This package adds the command `source-peek' which fetches the definition of
          the function at point (using different backends) and displays them inline in
          the current buffer.
        '';
      };
    };
  };
in {
  emacs = self.emacsHEAD;
  emacsPackagesNg = self.emacsHEADPackagesNg;

  emacs26PackagesNg = ((pkgs.emacsPackagesNgGen self.emacs26).overrideScope' overrides);
  emacsHEADPackagesNg = ((pkgs.emacsPackagesNgGen self.emacsHEAD).overrideScope' overrides);

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
        rev = "c418c85617babbe7b63730fefb71e2c87a0141af";
        sha256 = "1m374vaq5zaylds7g049vx1j8d67hv69pmdnsrnaypmj83gqf46x";
      };

      postInstall = ''
        mkdir -p $out/share/emacs/site-lisp
        cp ${./emacs/site-start.el} $out/share/emacs/site-lisp/site-start.el
        $out/bin/emacs --batch -f batch-byte-compile $out/share/emacs/site-lisp/site-start.el

        rm -rf $out/var
        rm -rf $out/share/emacs/${version}/site-lisp

        for srcdir in src lisp lwlib ; do
          dstdir=$out/share/emacs/${version}/$srcdir
          mkdir -p $dstdir
          find $srcdir -name "*.[chm]" -exec cp {} $dstdir \;
          cp $srcdir/TAGS $dstdir
          echo '((nil . ((tags-file-name . "TAGS"))))' > $dstdir/.dir-locals.el
        done

        mkdir -p $out/Applications
        mv nextstep/Emacs.app $out/Applications
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

      src = ./emacs/src;

      postInstall = ''
        mkdir -p $out/share/emacs/site-lisp
        cp ${./emacs/site-start.el} $out/share/emacs/site-lisp/site-start.el
        $out/bin/emacs --batch -f batch-byte-compile $out/share/emacs/site-lisp/site-start.el

        rm -rf $out/var
        rm -rf $out/share/emacs/${version}/site-lisp

        for srcdir in src lisp lwlib ; do
          dstdir=$out/share/emacs/${version}/$srcdir
          mkdir -p $dstdir
          find $srcdir -name "*.[chm]" -exec cp {} $dstdir \;
          cp $srcdir/TAGS $dstdir
          echo '((nil . ((tags-file-name . "TAGS"))))' > $dstdir/.dir-locals.el
        done

        mkdir -p $out/Applications
        mv nextstep/Emacs.app $out/Applications
      '';
    });
}
