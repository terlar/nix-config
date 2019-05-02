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
      version = "20190415.1807";
      src = pkgs.fetchFromGitHub {
        owner = "clojure-emacs";
        repo = "cider";
        rev = "d5b4bfcb2958e0252425674fd2aaa3746fb40d64";
        sha256 = "0a6xzanhwrf83xhcrapgrnvdsdfblrfna9iwbvbs015k3r8mignz";
        # date = 2019-04-15T18:07:28+02:00;
      };
    });

    # Follow master.
    company-mode = super.company-mode.overrideAttrs(attrs: {
      version = "20190415.0503";
      src = pkgs.fetchFromGitHub {
        owner = "company-mode";
        repo = "company-mode";
        rev = "3eda0ba23921d43b733f7975e56d490a34b9f30b";
        sha256 = "0shmv48bq9l5xm60dwx9lqyq6b39y3d7qjxdlah7dpipv5vhra42";
        # date = 2019-04-15T05:03:58+03:00;
      };
    });

    # Follow master.
    counsel = super.counsel.overrideAttrs(attrs: {
      version = "20190414.2226";
      src = pkgs.fetchFromGitHub {
        owner = "abo-abo";
        repo = "swiper";
        rev = "0e62f0d1f61b825ca5eb4b55e47ecb37b3e2834e";
        sha256 = "1pfa7vvv8krsvy7990irnmcsdwf490r7sgbn8bck0r5vv8dgp7vr";
        # date = 2019-04-14T22:26:30+03:00;
      };
    });
    ivy = super.ivy.overrideAttrs(attrs: {
      version = "20190414.2226";
      src = pkgs.fetchFromGitHub {
        owner = "abo-abo";
        repo = "swiper";
        rev = "0e62f0d1f61b825ca5eb4b55e47ecb37b3e2834e";
        sha256 = "1pfa7vvv8krsvy7990irnmcsdwf490r7sgbn8bck0r5vv8dgp7vr";
        # date = 2019-04-14T22:26:30+03:00;
      };
    });
    swiper = super.swiper.overrideAttrs(attrs: {
      version = "20190414.2226";
      src = pkgs.fetchFromGitHub {
        owner = "abo-abo";
        repo = "swiper";
        rev = "0e62f0d1f61b825ca5eb4b55e47ecb37b3e2834e";
        sha256 = "1pfa7vvv8krsvy7990irnmcsdwf490r7sgbn8bck0r5vv8dgp7vr";
        # date = 2019-04-14T22:26:30+03:00;
      };
    });

    # Follow master.
    objed = super.objed.overrideAttrs(attrs: {
      version = "20190416.1738";
      src = pkgs.fetchFromGitHub {
        owner = "clemera";
        repo = "objed";
        rev = "cf22d170b07172e034c457cc349336c85ec785d4";
        sha256 = "0k6bgl851jfzkr9d3xi757a1npqmk6kgkzklcqwl3h562agq5zv6";
        # date = 2019-04-16T17:38:31+02:00;
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
      version = "20190411.2346";
      src = pkgs.fetchFromGitHub {
        owner  = "orzechowskid";
        repo   = "flymake-eslint";
        rev    = "b0951ae2be75e19b7df4ef0e3947897869b837d1";
        sha256 = "1mnr3nfahjlxl3p4axkqhzzkfzp98vdl8j1hr8mnlm7payz6vkdm";
        # date = 2019-04-11T23:46:43-04:00;
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
