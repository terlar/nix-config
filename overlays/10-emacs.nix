self: pkgs:

let
  overrides = super: self: with self; let
    inherit (pkgs.stdenv) mkDerivation lib;
    inherit (pkgs) fetchurl fetchgit fetchFromGitHub;
    inherit (pkgs) writeText;
  in {
    # Fix conflict with wdired.
    all-the-icons-dired = all-the-icons-dired.overrideAttrs(attrs: {
      patches = [ ./emacs/patches/all-the-icons-dired.patch ];
    });

    # Fix code actions when using javascript-typescript-langserver.
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
      version = "20191015.1732";
      src = fetchFromGitHub {
        owner = "joaotavora";
        repo = "eglot";
        rev = "9359c153f4a9654133db40adb1264392876b9dd2";
        sha256 = "1grqax4yr9mi0g9jk6y6gssjypm75bbdmnxqqxbkxcggx80npzbq";
        # date = 2019-10-15T17:32:57+01:00;
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
      version = "20191014";

      src = fetchgit {
        url = https://code.orgmode.org/bzg/org-mode.git;
        rev = "8c5a78858121fa68da3729e07f7ee9dc86293c74";
        sha256 = "0zhdm55kc6q4f47jz7pxdijhkx6c5mm4a5wbqv1vbdcz7ydixhwi";
        # date = 2019-10-14T17:40:22+02:00;
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
      version = "20191004.1505";
      src = fetchFromGitHub {
        owner = "proofit404";
        repo = "relative-buffers";
        rev = "6064cd0b3cbd42c4a46c70fc396f05be71f42bd6";
        sha256 = "0wzxnbbzzjkzrnfdbdn7k172ad6mnhq5y3swcbilnk1w1a1lzyhn";
        # date = 2019-10-04T15:05:23+03:00;
      };
    });

    # Packages not in MELPA.
    apheleia = self.melpaBuild rec {
      pname   = "apheleia";
      version = "20190920.1712";
      src = fetchFromGitHub {
        owner  = "raxod502";
        repo   = "apheleia";
        rev    = "fab32d51a1db7c29b5f6e55d739254a96e372447";
        sha256 = "04pls7zahy4jfkikv6fvd9vfpm4glhyanmmkx79hgi9pwdv966rf";
        # date = 2019-09-20T17:12:09-07:00;
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
      version = "20190930.917";
      src = fetchFromGitHub {
        owner = "sebasmonia";
        repo = "awscli-capf";
        rev = "1a75f88f53a2969fe821c31e6857861d0a0c0a5e";
        sha256 = "13ry0lhh8ss93h9c60gc02i28bwc70jb4fzqmvw778fk0shj8jxn";
        # date = 2019-09-30T09:17:12-06:00;
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
      version = "20191015.648";
      src = fetchFromGitHub {
        owner  = "nyyManni";
        repo   = "ejira";
        rev    = "64f839ae8c44bc66228aed453c58caeeecf2f571";
        sha256 = "04f40iklhkp1azxb6jivwzjbw8iig0dwbg9ww598nghp8b9vilmz";
        # date = 2019-10-15T06:48:34+03:00;
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
      version = "20170424.347";
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
