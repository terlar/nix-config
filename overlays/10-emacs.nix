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
      version = "20190626.1517";
      src = pkgs.fetchFromGitHub {
        owner = "clojure-emacs";
        repo = "cider";
        rev = "04cde7c9f6884f443d5525c46d267d1b39f989c6";
        sha256 = "1gay8jysill2p5vaawlk7vwdbc61n0jh5qqh2jwpgwfjpk64r2ni";
        # date = 2019-06-26T15:17:13+02:00;
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
      version = "20190627.2144";
      src = pkgs.fetchFromGitHub {
        owner = "abo-abo";
        repo = "swiper";
        rev = "d260c48f88c3d500771a9764d0d4d13e45a6885b";
        sha256 = "15w3wm3bbv0nzgfa7y5k8sgz2ld4shvi6mcz3rj1zsk39j30qjf1";
        # date = 2019-06-27T21:44:10+02:00;
      };
    });
    ivy = super.ivy.overrideAttrs(attrs: {
      version = "20190627.2144";
      src = pkgs.fetchFromGitHub {
        owner = "abo-abo";
        repo = "swiper";
        rev = "d260c48f88c3d500771a9764d0d4d13e45a6885b";
        sha256 = "15w3wm3bbv0nzgfa7y5k8sgz2ld4shvi6mcz3rj1zsk39j30qjf1";
        # date = 2019-06-27T21:44:10+02:00;
      };
    });
    swiper = super.swiper.overrideAttrs(attrs: {
      version = "20190627.2144";
      src = pkgs.fetchFromGitHub {
        owner = "abo-abo";
        repo = "swiper";
        rev = "d260c48f88c3d500771a9764d0d4d13e45a6885b";
        sha256 = "15w3wm3bbv0nzgfa7y5k8sgz2ld4shvi6mcz3rj1zsk39j30qjf1";
        # date = 2019-06-27T21:44:10+02:00;
      };
    });

    # Follow master.
    eglot = super.eglot.overrideAttrs(attrs: {
      version = "20190702.2258";
      src = pkgs.fetchFromGitHub {
        owner = "joaotavora";
        repo = "eglot";
        rev = "d6508e06b3569f2c2fa6d09326eadad47f41345a";
        sha256 = "0148ml7g0pgxczjyq1f3prc50rwqvmpnix1lc7svy4h9izng80l4";
        # date = 2019-07-02T22:58:41+01:00;
      };
    });

    # Follow master.
    magit = super.magit.overrideAttrs(attrs: {
      version = "20190713.1914";
      src = pkgs.fetchFromGitHub {
        owner = "magit";
        repo = "magit";
        rev = "5362cf75f0a72be1f75efc62aed377b9c18251a1";
        sha256 = "1z5j21lz478cz5p81xpnhy02a0yylzvkyhm8qpa8m1cis35nsq39";
        # date = 2019-07-13T19:14:10+02:00;
      };
    });

    # Follow master.
    nix-mode = super.nix-mode.overrideAttrs(attrs: {
      version = "20190627.1252";
      src = pkgs.fetchFromGitHub {
        owner = "nixos";
        repo = "nix-mode";
        rev = "c577957d668ea9513cc1cafc911ef6789d9fcb14";
        sha256 = "0q0i8l7yz0jn6a4bn3sg7brk39fcycbcx8gncx1z919c7jhgffm0";
        # date = 2019-06-27T12:52:16-04:00;
      };
    });

    # Follow master.
    objed = super.objed.overrideAttrs(attrs: {
      version = "20190530.1636";
      src = pkgs.fetchFromGitHub {
        owner = "clemera";
        repo = "objed";
        rev = "70cf23ee694651e9b6feada6e380318e519b649b";
        sha256 = "080nlv4hdhmk791g6r15p04prgmhqyzdrphaiz5mj1zdws2yjhmb";
        # date = 2019-05-30T16:36:31+02:00;
      };
    });

    # Packages not in MELPA.
    apheleia = self.melpaBuild rec {
      pname   = "apheleia";
      version = "20190717.1126";
      src = pkgs.fetchFromGitHub {
        owner  = "raxod502";
        repo   = "apheleia";
        rev    = "4e9f797210bd0e3777bf4f973ce137c43b1506fb";
        sha256 = "099drn6a98469xmvxzzrb0a6l0c1v1xpbs42zkrbnyzkv2b0x70f";
        # date = 2019-07-17T11:26:52-07:00;
      };
      recipe = pkgs.writeText "recipe" ''
        (apheleia :repo "raxod502/apheleia" :fetcher github)
      '';

      meta = {
        description = "Run code formatter on buffer contents without moving point, using RCS patches and dynamic programming.";
      };
    };

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
        rev    = "d4be92ea779ea333b599fd125817f943a676a63a";
        sha256 = "1x0ipsg0gd5lflx7kyyaz7zv6xnjzmhh1k32f01qr69zarf31nw0";
        # date = 2019-05-21T00:11:35-04:00;
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
      version = "20190714.1124";
      src = pkgs.fetchFromGitHub {
        owner = "sebasmonia";
        repo = "pepita";
        rev = "c73e1e89e4928eb32ad9e0c8bf78cdc4caf553db";
        sha256 = "1k1wn3fa3y5c966isgchpnx2g3vqnlxz26p466srycpd8ya4gqy1";
        # date = 2019-07-14T11:24:36-06:00;
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
      version = "20190526.1545";
      src = pkgs.fetchFromGitHub {
        owner  = "realgud";
        repo   = "realgud-node-inspect";
        rev    = "c3ed48cf3bc2b28f9fd23bcf60ea13a3cf019fc8";
        sha256 = "00ywz4kp90wkfi1ncn9zj6vjw9igiv34gvx6fqfi8ha3q5xljzps";
        # date = 2019-05-26T15:45:49-04:00;
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
