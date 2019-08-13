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
      version = "20190805.1927";
      src = pkgs.fetchFromGitHub {
        owner = "clojure-emacs";
        repo = "cider";
        rev = "e0fb1c9e87623b343efd5edb2c869e89ff18f895";
        sha256 = "04kiyf4mcdz34gxqi5iks9dxhg8yj32kajigx0qb3f8scpxfcjhr";
        # date = 2019-08-05T18:19:27+02:00;
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
      version = "20190807.1906";
      src = pkgs.fetchFromGitHub {
        owner = "abo-abo";
        repo = "swiper";
        rev = "0be5b5818c1d96b67aa314c9f4031a1d9a730399";
        sha256 = "1h1wj7l5wdrqg4njvwzn8rqw771hjllzgwml3v91kbz6x7j7lqzk";
        # date = 2019-08-07T19:06:33+02:00;
      };
    });
    ivy = super.ivy.overrideAttrs(attrs: {
      version = "20190807.1906";
      src = pkgs.fetchFromGitHub {
        owner = "abo-abo";
        repo = "swiper";
        rev = "0be5b5818c1d96b67aa314c9f4031a1d9a730399";
        sha256 = "1h1wj7l5wdrqg4njvwzn8rqw771hjllzgwml3v91kbz6x7j7lqzk";
        # date = 2019-08-07T19:06:33+02:00;
      };
    });
    swiper = super.swiper.overrideAttrs(attrs: {
      version = "20190807.1906";
      src = pkgs.fetchFromGitHub {
        owner = "abo-abo";
        repo = "swiper";
        rev = "0be5b5818c1d96b67aa314c9f4031a1d9a730399";
        sha256 = "1h1wj7l5wdrqg4njvwzn8rqw771hjllzgwml3v91kbz6x7j7lqzk";
        # date = 2019-08-07T19:06:33+02:00;
      };
    });

    # Follow master.
    eglot = super.eglot.overrideAttrs(attrs: {
      version = "20190718.2036";
      src = pkgs.fetchFromGitHub {
        owner = "joaotavora";
        repo = "eglot";
        rev = "f45fdc6674a6cda16dc71966334f5346500e9498";
        sha256 = "18n4w2cxzhc6yyr7bdggb19hmzk2h7m1d6r7nnr90ldryb05yyf0";
        # date = 2019-07-18T20:36:56+01:00;
      };
    });

    # Follow master.
    flymake-diagnostic-at-point = super.flymake-diagnostic-at-point.overrideAttrs(attrs: {
      version = "20190810.2232";
      src = pkgs.fetchFromGitHub {
        owner = "terlar";
        repo = "flymake-diagnostic-at-point";
        rev = "8a4f5c1160cbb6c2464db9f5c104812b0c0c6d4f";
        sha256 = "17hkqspg2w1yjlcz3g6kxxrcz13202a1x2ha6rdp4f1bgam5lhzq";
        # date = 2019-08-10T22:32:04+02:00;
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
      version = "20190717.1053";
      src = pkgs.fetchFromGitHub {
        owner = "clemera";
        repo = "objed";
        rev = "fea114824e11fdae7871fb3b5ddf4ed2472cbda0";
        sha256 = "0lf88ivfsl5la075jg1y56kf0v96hp2539b54lwyabz0rpc0c7in";
        # date = 2019-07-17T10:53:58+02:00;
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

    ejira = self.melpaBuild rec {
      pname   = "ejira";
      version = "20181212.1420";
      src = pkgs.fetchFromGitHub {
        owner  = "nyyManni";
        repo   = "ejira";
        rev    = "9ef57f96456f0bb3be17befb000d960f5ac766b4";
        sha256 = "056k1wczaqkvqx24hfcjfixknr51aqk2fmy7kgrsvhygw7b6gcla";
        # date = 2018-12-12T14:20:51+02:00;
      };
      recipe = pkgs.writeText "recipe" ''
        (ejira :repo "nyyManni/ejira" :fetcher github)
      '';
      packageRequires = [ self.language-detection self.ox-jira ];

      meta = {
        description = "JIRA integration to Emacs org-mode.";
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
      version = "20190720.1028";
      src = pkgs.fetchFromGitHub {
        owner  = "orzechowskid";
        repo   = "flymake-eslint";
        rev    = "5624f61c782c91710014620ebbaadab44a7e2b1f";
        sha256 = "113hbdsgp950safyry3a2bpml3h2jjhypmfyjjyj3fibiigx9fmi";
        # date = 2019-07-20T11:01:37-04:00;
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
      version = "20190801.1305";
      src = pkgs.fetchFromGitHub {
        owner = "sebasmonia";
        repo = "pepita";
        rev = "1d67dad08cb994dd2fa637ea591db14cbb00d644";
        sha256 = "09lqjssg72bq437cvg15dxmy7j446raaknvkp7pl5357vgmqcdy0";
        # date = 2019-08-01T13:05:21-06:00;
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

    terraform-doc = self.melpaBuild rec {
      pname   = "terraform-doc";
      version = "20190813.1954";
      src = pkgs.fetchFromGitHub {
        owner  = "txgvnn";
        repo   = "terraform-doc";
        rev    = "e07d8a9b26567ea4f4252336ee70d488c25ba30a";
        sha256 = "0l16a0j2v180rfx6kwn6dw8i7b1dw8j7ljrf5pib2nzrl54rylr3";
        # date = 2019-08-13T19:54:32+07:00;
      };
      recipe = pkgs.writeText "recipe" ''
        (terraform-doc :repo "txgvnn/terraform-doc" :fetcher github)
      '';

      meta = {
        description = "Lookup docs from Terraform hompage";
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
