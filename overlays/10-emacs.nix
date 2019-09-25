self: pkgs:

let
  overrides = super: self: with self; let
    inherit (pkgs.stdenv) mkDerivation lib;
    inherit (pkgs) fetchurl fetchgit fetchFromGitHub;
    inherit (pkgs) writeText;
  in {
    all-the-icons-dired = all-the-icons-dired.overrideAttrs(attrs: {
      patches = [ ./emacs/patches/all-the-icons-dired.patch ];
    });

    jsonrpc = let
      src = jsonrpc.src;
      patch = ./emacs/patches/jsonrpc.patch;
      patchedSrc = mkDerivation {
        name = "${src.name}-patched";
        inherit src;
        phases = [ "patchPhase" ];
        patchPhase = "patch $src -o $out < ${patch}";
      };
    in self.elpaBuild rec {
      inherit (jsonrpc) pname ename version meta;
      src = patchedSrc;
      packageRequires = [ super.emacs ];
    };

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

    org = mkDerivation rec {
      name = "emacs-org-${version}";
      version = "20190830";

      src = fetchgit {
        url = https://code.orgmode.org/bzg/org-mode.git;
        rev = "fcc0d8f509f12ca55efe548bf78150d7ca0fc95a";
        sha256 = "0ybfvy84vj4znh644nxl17n1hjcwvsvn0dcggpsy98svb39glapa";
        # date = 2019-08-30T08:51:02+02:00;
      };

      preBuild = ''
        makeFlagsArray=(
          prefix="$out/share"
          ORG_ADD_CONTRIB="org* ox*"
        );
      '';

      preInstall = ''
        perl -i -pe "s%/usr/share%$out%;" local.mk
      '';

      buildInputs = [ super.emacs ] ++ (with pkgs; [ texinfo perl which ]);

      meta = {
        homepage = "https://elpa.gnu.org/packages/org.html";
        license = licenses.free;
      };
    };

    relative-buffers = relative-buffers.overrideAttrs(attrs: {
      version = "20190914.415";
      src = fetchFromGitHub {
        owner = "terlar";
        repo = "relative-buffers";
        rev = "69410dde9798b81b2640de47f1cfb0521d079c6f";
        sha256 = "14nqs14ml33wlrm268dpijs0n2b12yrlysk1qd62fc7k5hvz9wxl";
        # date = 2019-09-14T04:15:30+02:00;
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
        rev = "6670b4db6bd35f0ea9ede598a9c17384046f4400";
        sha256 = "0pnz8jiapd8i8ya2j9lns22rg903iq65pby89wpmz7cidzg6lgf0";
        # date = 2019-09-09T09:34:19-06:00;
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
  };
in {
  emacs = self.emacsHEAD;
  emacsPackages = self.emacsHEADPackages;
  emacsOverrides = overrides;

  emacsHEADPackages = ((pkgs.emacsPackagesFor self.emacsHEAD).overrideScope' overrides);

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
