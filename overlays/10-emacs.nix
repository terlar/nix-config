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
    rspec-mode = super.rspec-mode.overrideAttrs(attrs: {
      patches = [ ./emacs/patches/rspec-mode.patch ];
    });

    # Follow master.
    company-mode = super.company-mode.overrideAttrs(attrs: {
      version = "20190221.1727";
      src = pkgs.fetchFromGitHub {
        owner = "company-mode";
        repo = "company-mode";
        rev = "20fe01542bf7665ba90f9fe1a86cbe0eea4d9f8a";
        sha256 = "10q1709ikf5pk32c9wznz30sd8q41lp8qq1k9qrbcdyxxgizzqsf";
        # date = 2019-02-21T17:27:47+03:00;
      };
    });

    # Follow master.
    dumb-jump = super.dumb-jump.overrideAttrs(attrs: {
      version = "20190221.0923";
      src = pkgs.fetchFromGitHub {
        owner = "jacktasia";
        repo = "dumb-jump";
        rev = "64fcd1ca3181723fd8f7af3ea982f822cf601539";
        sha256 = "0sfp8y12p517xawx10qg7g4w2khd22942wa9287v2viwv34hmdqh";
        # date = 2019-02-21T09:23:27-08:00;
      };
    });

    # Follow master.
    eglot = super.eglot.overrideAttrs(attrs: {
      version = "20190213.0924";
      src = pkgs.fetchFromGitHub {
        owner = "joaotavora";
        repo = "eglot";
        rev = "7d6e3cf5d7ae098aa6c8572343c8bc9b8453aace";
        sha256 = "1q616yp9zi9a76sjb9f901r4cck40p8f5rgxmdwsavagl5w8d8cz";
        # date = 2019-02-13T09:24:02+00:00;
      };
    });

    # Follow master.
    nix-mode = super.nix-mode.overrideAttrs(attrs: {
      version = "20190119.1025";
      src = pkgs.fetchFromGitHub {
        owner = "nixos";
        repo = "nix-mode";
        rev = "1e53bed4d47c526c71113569f592c82845a17784";
        sha256 = "172s5lxlns633gbi6sq6iws269chalh5k501n3wffp5i3b2xzdyq";
        # date = 2019-01-19T10:25:21+01:00;
      };
    });

    # Fix display function for Emacs 27.0.50.
    imenu-list = super.imenu-list.overrideAttrs(attrs: {
      version = "20190115.2330";
      src = pkgs.fetchFromGitHub {
        owner = "bmag";
        repo = "imenu-list";
        rev = "46008738f8fef578a763c308cf6695e5b4d4aa77";
        sha256 = "14l3yw9y1nk103s7z5i1fmd6kvlb2p6ayi6sf9l1x1ydg9glrpl8";
        # date = 2019-01-15T23:30:04+02:00;
      };
    });

    # Fix wrong hash being received.
    lua-mode = super.lua-mode.overrideAttrs(attrs: {
      version = "20190113.1350";
      src = pkgs.fetchFromGitHub {
        owner = "immerrr";
        repo = "lua-mode";
        rev = "95c64bb5634035630e8c59d10d4a1d1003265743";
        sha256 = "0cawb544qylifkvqads307n0nfqg7lvyphqbpbzr2xvr5iyi4901";
        # date = 2019-01-13T13:50:39+03:00;
      };
    });

    # Support disabling spacer lines.
    quick-peek = super.quick-peek.overrideAttrs(attrs: {
      version = "20190208.1015";
      src = pkgs.fetchFromGitHub {
        owner = "cpitclaudel";
        repo = "quick-peek";
        rev = "fd8a6c81422932539d221f39f18c90f2811f2dd9";
        sha256 = "18jr3syd7jd809qq1j61zwaaclmqn24qyb0mv0q8sj6ac4vzl1c3";
        # date = 2019-02-08T10:15:39-05:00;
      };
    });

    # Packages not in MELPA.
    eldoc-posframe = self.melpaBuild rec {
      pname   = "eldoc-posframe";
      version = "20190209.1123";
      src = pkgs.fetchFromGitHub {
        owner  = "terlar";
        repo   = "eldoc-posframe";
        rev    = "2e012a097dfab66a05a858b1486bba9f70956823";
        sha256 = "1pn1g8mwcgxpavwj9z8rr244pak3n7jqbswjav5bni89s4wm9rhz";
        # date = 2019-02-09T11:23:21+01:00;
      };
      recipe = pkgs.writeText "recipe" ''
        (eldoc-posframe :repo "terlar/eldoc-posframe" :fetcher github)
      '';

      meta = {
        description = "Display eldoc information in a posframe.";
      };
    };

    org-pretty-table = self.melpaBuild rec {
      pname   = "org-pretty-table";
      version = "20131129.1610";
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

    perfect-margin = self.melpaBuild rec {
      pname   = "perfect-margin";
      version = "20190211.0308";
      src = pkgs.fetchFromGitHub {
        owner  = "mpwang";
        repo   = "perfect-margin";
        rev    = "d5ffa1ffcf38dc93e0887849a11bc19a96fcde00";
        sha256 = "0d5v2yh2fi3amysh87fy6pfz47mqzri4gv9x8svmy1arrwaxlybi";
        # date = 2019-02-11T03:08:46+08:00;
      };
      recipe = pkgs.writeText "recipe" ''
        (perfect-margin :repo "mpwang/perfect-margin" :fetcher github)
      '';

      meta = {
        description = "Auto center emacs windows, work with minimap and/or linum-mode.";
      };
    };

    rotate-text = self.melpaBuild rec {
      pname   = "rotate-text";
      version = "20090413.2236";
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
      version = "20170424.0347";
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

  emacsOverrides = overrides;

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
      '' + lib.optionalString stdenv.isDarwin ''
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
      '' + lib.optionalString stdenv.isDarwin ''
        mkdir -p $out/Applications
        mv nextstep/Emacs.app $out/Applications
      '';
    });
}
