self: pkgs:

let
  overrides = super: self: with self; let
    inherit (pkgs.stdenv) mkDerivation lib;
    inherit (pkgs) fetchurl fetchgit fetchFromGitHub;
    inherit (pkgs) writeText;
  in {
    kubernetes = kubernetes.overrideAttrs(attrs: {
      buildInputs = attrs.buildInputs ++ [ pkgs.git ];
    });

    all-the-icons-dired = all-the-icons-dired.overrideAttrs(attrs: {
      patches = [ ./emacs/patches/all-the-icons-dired.patch ];
    });
    rspec-mode = rspec-mode.overrideAttrs(attrs: {
      patches = [ ./emacs/patches/rspec-mode.patch ];
    });

    # Follow master.
    eglot = eglot.overrideAttrs(attrs: {
      version = "20190826.2310";
      src = fetchFromGitHub {
        owner = "terlar";
        repo = "eglot";
        rev = "15228b564d9fe335137f7b4722dc35e1eea0a593";
        sha256 = "179y4scyynmikc6gvz9zihhk7k23794s8z9qagxqrdk5v6lw7mlc";
        # date = 2019-08-26T23:10:17+02:00;
      };
    });

    flymake-diagnostic-at-point = flymake-diagnostic-at-point.overrideAttrs(attrs: {
      version = "20190810.2232";
      src = fetchFromGitHub {
        owner = "terlar";
        repo = "flymake-diagnostic-at-point";
        rev = "8a4f5c1160cbb6c2464db9f5c104812b0c0c6d4f";
        sha256 = "17hkqspg2w1yjlcz3g6kxxrcz13202a1x2ha6rdp4f1bgam5lhzq";
        # date = 2019-08-10T22:32:04+02:00;
      };
    });

    # Packages not in MELPA.
    apheleia = self.melpaBuild rec {
      pname   = "apheleia";
      version = "20190815.1748";
      src = fetchFromGitHub {
        owner  = "raxod502";
        repo   = "apheleia";
        rev    = "49568bb1668c05050cd7ec014c94405435e596b3";
        sha256 = "1vv54spksf2bk64sihd29r857zx56ycay5p8v8vhm8w68ia9vqbj";
        # date = 2019-08-15T17:48:56-07:00;
      };
      recipe = writeText "recipe" ''
        (apheleia :repo "raxod502/apheleia" :fetcher github)
      '';

      meta = {
        description = "Run code formatter on buffer contents without moving point, using RCS patches and dynamic programming.";
      };
    };

    awscli-capf = self.melpaBuild rec {
      pname   = "awscli-capf";
      version = "20190819.756";
      src = fetchFromGitHub {
        owner = "sebasmonia";
        repo = "awscli-capf";
        rev = "42ff59b14b47a5cb3bf0cb91fdf74f8f8ccbe123";
        sha256 = "0js100gchn14wp8mgxhhdlzjh0d37ydxn53ryznl2wrl377lk3xb";
        # date = 2019-08-19T07:56:04-06:00;
      };
      recipe = writeText "recipe" ''
        (awscli-capf
          :fetcher github
          :repo "sebasmonia/awscli-capf"
          :files (:defaults "awscli-capf-docs.data"))
      '';
      packageRequires = [ self.company];

      meta = {
        description = "Completion at point function for the AWS CLI";
      };
    };

    ejira = self.melpaBuild rec {
      pname   = "ejira";
      version = "20181212.1420";
      src = fetchFromGitHub {
        owner  = "nyyManni";
        repo   = "ejira";
        rev    = "9ef57f96456f0bb3be17befb000d960f5ac766b4";
        sha256 = "056k1wczaqkvqx24hfcjfixknr51aqk2fmy7kgrsvhygw7b6gcla";
        # date = 2018-12-12T14:20:51+02:00;
      };
      recipe = writeText "recipe" ''
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
      src = fetchFromGitHub {
        owner  = "terlar";
        repo   = "eldoc-posframe";
        rev    = "2e012a097dfab66a05a858b1486bba9f70956823";
        sha256 = "1pn1g8mwcgxpavwj9z8rr244pak3n7jqbswjav5bni89s4wm9rhz";
        # date = 2019-02-09T11:23:21+01:00;
      };
      recipe = writeText "recipe" ''
        (eldoc-posframe :repo "terlar/eldoc-posframe" :fetcher github)
      '';

      meta = {
        description = "Display eldoc information in a posframe.";
      };
    };

    org-pretty-table = self.melpaBuild rec {
      pname   = "org-pretty-table";
      version = "20131129.1610";
      src = fetchFromGitHub {
        owner  = "fuco1";
        repo   = "org-pretty-table";
        rev    = "0dca6f3156dd1eb0a42f08ac2ad89259637a16b5";
        sha256 = "09avbl1mmgs3b1ya0rvv9kswq2k7d133zgr18cazl3jkpvh35lxg";
        # date = 2013-11-29T16:10:09+01:00;
      };
      recipe = writeText "recipe" ''
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

    source-peek = self.melpaBuild rec {
      pname   = "source-peek";
      version = "20170424.0347";
      src = fetchFromGitHub {
        owner  = "iqbalansari";
        repo   = "emacs-source-peek";
        rev    = "fa94ed1def1e44f3c3999d355599d1dd9bc44dab";
        sha256 = "14ai66c7j2k04a0vav92ybaikcc8cng5i5vy0iwpg7b2cws8a2zg";
        # date = 2017-04-24T03:47:10+05:30;
      };
      recipe = writeText "recipe" ''
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
      src = fetchFromGitHub {
        owner  = "txgvnn";
        repo   = "terraform-doc";
        rev    = "e07d8a9b26567ea4f4252336ee70d488c25ba30a";
        sha256 = "0l16a0j2v180rfx6kwn6dw8i7b1dw8j7ljrf5pib2nzrl54rylr3";
        # date = 2019-08-13T19:54:32+07:00;
      };
      recipe = writeText "recipe" ''
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

  emacsHEADPackagesNg = ((pkgs.emacsPackagesNgGen self.emacsHEAD).overrideScope' overrides);

  emacsHEAD = with pkgs; stdenv.lib.overrideDerivation
    (emacs26.override { srcRepo = true; })
    (attrs: rec {
      name = "emacs-${version}${versionModifier}";
      version = "27.0";
      versionModifier = ".50";

      buildInputs = emacs26.buildInputs ++
                    [ git libpng.dev libjpeg.dev libungif libtiff.dev librsvg.dev ];

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
