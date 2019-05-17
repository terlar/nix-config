self: pkgs:

let
  overrides = self: super: {
    kubernetes = super.kubernetes.overrideAttrs(attrs: {
      buildInputs = attrs.buildInputs ++ [ pkgs.git ];
    });

    all-the-icons-dired = super.all-the-icons-dired.overrideAttrs(attrs: {
      patches = [ ./emacs/patches/all-the-icons-dired.patch ];
    });
    rspec-mode = super.rspec-mode.overrideAttrs(attrs: {
      patches = [ ./emacs/patches/rspec-mode.patch ];
    });

    # Follow master.
    cider = super.cider.overrideAttrs(attrs: {
      version = "20190419.1509";
      src = pkgs.fetchFromGitHub {
        owner = "clojure-emacs";
        repo = "cider";
        rev = "3d85b4dc9ce5e130b61186334bc8f732ebeeaada";
        sha256 = "1a39dd29dlxp34xjn6zpinqqfcmxrhzj3h6gi1dl1qjr64d76bfq";
        # date = 2019-04-19T15:09:30+03:00;
      };
    });

    # Follow master.
    company-mode = super.company-mode.overrideAttrs(attrs: {
      version = "20190430.2152";
      src = pkgs.fetchFromGitHub {
        owner = "company-mode";
        repo = "company-mode";
        rev = "ad6ff0eecca99dc5ac8b6a8a6174df7d2ad88ae7";
        sha256 = "0cps5sl9iij1wrpcnhi7xqv58cqsrswhc8r7hj1c00w8288z978w";
        # date = 2019-04-30T21:52:15+03:00;
      };
    });

    # Follow master.
    counsel = super.counsel.overrideAttrs(attrs: {
      version = "20190508.1542";
      src = pkgs.fetchFromGitHub {
        owner = "abo-abo";
        repo = "swiper";
        rev = "b49f17fa47083c008877c4c9e0b32f2ee610af5f";
        sha256 = "10mhipn1dic9sf5k4yxndilwmwphcgqbpqnm3svj3h1br3l5b7wq";
        # date = 2019-05-08T15:42:47+02:00;
      };
    });
    ivy = super.ivy.overrideAttrs(attrs: {
      version = "20190508.1542";
      src = pkgs.fetchFromGitHub {
        owner = "abo-abo";
        repo = "swiper";
        rev = "b49f17fa47083c008877c4c9e0b32f2ee610af5f";
        sha256 = "10mhipn1dic9sf5k4yxndilwmwphcgqbpqnm3svj3h1br3l5b7wq";
        # date = 2019-05-08T15:42:47+02:00;
      };
    });
    swiper = super.swiper.overrideAttrs(attrs: {
      version = "20190508.1542";
      src = pkgs.fetchFromGitHub {
        owner = "abo-abo";
        repo = "swiper";
        rev = "b49f17fa47083c008877c4c9e0b32f2ee610af5f";
        sha256 = "10mhipn1dic9sf5k4yxndilwmwphcgqbpqnm3svj3h1br3l5b7wq";
        # date = 2019-05-08T15:42:47+02:00;
      };
    });

    # Follow master.
    eglot = super.eglot.overrideAttrs(attrs: {
      version = "20190508.1233";
      src = pkgs.fetchFromGitHub {
        owner = "joaotavora";
        repo = "eglot";
        rev = "b868ee168a3c72debb7843d23468c4bba83b95f5";
        sha256 = "1w4gyz1pbf3abj2gqnq5s3h8rk1ybqs5g9lhswwamcynyzzb88b5";
        # date = 2019-05-08T12:33:34+01:00;
      };
    });

    # Follow master.
    objed = super.objed.overrideAttrs(attrs: {
      version = "20190502.1951";
      src = pkgs.fetchFromGitHub {
        owner = "clemera";
        repo = "objed";
        rev = "4d1a4453a50fe21fd2de0ddb24871d14f33220b3";
        sha256 = "01bgli9b5iw0hp2m2ibwby5l14xsinmhm4has59r04wg3jrycia4";
        # date = 2019-05-02T19:51:42+02:00;
      };
    });

    # Packages not in MELPA.
    comment-or-uncomment-sexp = self.melpaBuild rec {
      pname   = "comment-or-uncomment-sexp";
      version = "20190225.0822";
      src = pkgs.fetchFromGitHub {
        owner  = "malabarba";
        repo   = "comment-or-uncomment-sexp";
        rev    = "bec730d3fc1e6c17ff1339eb134af16c034a4d95";
        sha256 = "1jhyr854qraza75hjza8fjz2s06iydmdsa61vf5bf2kj5g1bfqkj";
        # date = 2019-02-25T08:22:09-03:00;
      };
      recipe = pkgs.writeText "recipe" ''
        (comment-or-uncomment-sexp :repo "malabarba/comment-or-uncomment-sexp" :fetcher github)
      '';

      meta = {
        description = "Emacs-lisp command for inteligently commenting and commenting the sexp under point.";
      };
    };

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

    flymake-eslint = self.melpaBuild rec {
      pname = "flymake-eslint";
      version = "20190517.1028";
      src = pkgs.fetchFromGitHub {
        owner  = "orzechowskid";
        repo   = "flymake-eslint";
        rev    = "29d86fdc828074744babbeaa622881dd77bed90a";
        sha256 = "1zbrxkgi3nn12x3sslxwq06fr8mf6r2yxbphxy0jad3aaa40r7gr";
        # date = 2019-05-17T10:28:04-04:00;
      };
      recipe = pkgs.writeText "recipe" ''
        (flymake-eslint :fetcher github :repo "orzechowskid/flymake-eslint"))
      '';

      meta = {
        description = "Flymake backend for Javascript using eslint";
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

    pepita = self.melpaBuild rec {
      pname   = "pepita";
      version = "20190509.2131";
      src = pkgs.fetchFromGitHub {
        owner = "sebasmonia";
        repo = "pepita";
        rev = "c3f5956326895dc8f01329bdad139d69f60dcf8d";
        sha256 = "0m6hkd0pn5i73vci6ni28f8nyxr9jpm5c4lwjk419k63m8znjd92";
        # date = 2019-05-09T21:31:07-06:00;
      };
      recipe = pkgs.writeText "recipe" ''
        (pepita :repo "sebasmonia/pepita" :fetcher github)
      '';
      packageRequires = [ self.csv ];

      meta = {
        description = "Run Splunk search from Emacs";
      };
    };

    realgud-node-inspect = self.melpaBuild rec {
      pname = "realgud-node-inspect";
      version = "20190317.1812";
      src = pkgs.fetchFromGitHub {
        owner  = "realgud";
        repo   = "realgud-node-inspect";
        rev    = "e9590727c981caf424b8736448a29f4111d3e8c1";
        sha256 = "16yrk84d0si5yghsqxbnjy8gh27cwmra42d85mhas18xvyx5dm4k";
        # date = 2019-03-17T18:12:25-04:00;
      };
      recipe = pkgs.writeText "recipe" ''
        (realgud-node-inspect
        :fetcher github
        :repo "realgud/realgud-node-inspect"
        :files ("realgud-node-inspect.el" "node-inspect/.nosearch"
        ("node-inspect" "node-inspect/*.el")))
      '';

      meta = {
        description = "realgud support for newer node inspect";
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
