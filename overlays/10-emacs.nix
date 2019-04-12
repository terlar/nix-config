self: pkgs:

let
  overrides = self: super: {
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
    cider = super.cider.overrideAttrs(attrs: {
      version = "20190313.1658";
      src = pkgs.fetchFromGitHub {
        owner = "clojure-emacs";
        repo = "cider";
        rev = "4d98e3b8fff958380f04d26010ad05ebf2b7feeb";
        sha256 = "0ycaahjnrj7slx5h8fl42mpfvkv4xd72fpbh71hjb2nv7qyk0sa3";
        # date = 2019-03-13T16:58:41+02:00;
      };
    });

    # Follow master.
    company-mode = super.company-mode.overrideAttrs(attrs: {
      version = "20190316.0301";
      src = pkgs.fetchFromGitHub {
        owner = "company-mode";
        repo = "company-mode";
        rev = "f965786c589f95a00901028e49f1eae415053f08";
        sha256 = "0pzxim56nxynmlq459ljfy82nb6qgq1izy19ldwnyc36x1mqccgf";
        # date = 2019-03-16T03:01:51+02:00;
      };
    });

    # Follow master.
    counsel = super.counsel.overrideAttrs(attrs: {
      version = "20190412.1043";
      src = pkgs.fetchFromGitHub {
        owner = "abo-abo";
        repo = "swiper";
        rev = "2221a5c4625639bb3df3f3248efc32c43cf8a924";
        sha256 = "0ggqd0fg57idav2g64iapz4pvdh0169bim6isz9qlm5cqw7iivxk";
        # date = 2019-04-12T10:43:56+02:00;
      };
    });
    ivy = super.ivy.overrideAttrs(attrs: {
      version = "20190412.1043";
      src = pkgs.fetchFromGitHub {
        owner = "abo-abo";
        repo = "swiper";
        rev = "2221a5c4625639bb3df3f3248efc32c43cf8a924";
        sha256 = "0ggqd0fg57idav2g64iapz4pvdh0169bim6isz9qlm5cqw7iivxk";
        # date = 2019-04-12T10:43:56+02:00;
      };
    });
    swiper = super.swiper.overrideAttrs(attrs: {
      version = "20190412.1043";
      src = pkgs.fetchFromGitHub {
        owner = "abo-abo";
        repo = "swiper";
        rev = "2221a5c4625639bb3df3f3248efc32c43cf8a924";
        sha256 = "0ggqd0fg57idav2g64iapz4pvdh0169bim6isz9qlm5cqw7iivxk";
        # date = 2019-04-12T10:43:56+02:00;
      };
    });

    # Follow master.
    deadgrep = super.deadgrep.overrideAttrs(attrs: {
      version = "20190314.2207";
      src = pkgs.fetchFromGitHub {
        owner = "wilfred";
        repo = "deadgrep";
        rev = "160e7adb7f043fc42ba6d4d891ad50ef1e063be7";
        sha256 = "1sm92hj4ilq0h82fy5k5nzn7jq56yw2665ikqdcj89k9xldin6xi";
        # date = 2019-03-14T22:07:10+00:00;
      };
    });

    # Follow master.
    dumb-jump = super.dumb-jump.overrideAttrs(attrs: {
      version = "20190314.2232";
      src = pkgs.fetchFromGitHub {
        owner = "jacktasia";
        repo = "dumb-jump";
        rev = "59f91b408f6228be035ece10a79b5d460430116a";
        sha256 = "0iqxk9i2qfav5c59k1pjarq2f6k8y1qxdscx3d36lhnh5jc5ydbz";
        # date = 2019-03-14T22:32:57-07:00;
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

    # Follow master.
    objed = super.objed.overrideAttrs(attrs: {
      version = "20190315.1756";
      src = pkgs.fetchFromGitHub {
        owner = "clemera";
        repo = "objed";
        rev = "aa8f32d155dbbcbdabf388acfec5ae09cadedf9a";
        sha256 = "1z2db1n8q2zfrscviagygjvnbz0lzxx86jq5z4ri81shhja93j5r";
        # date = 2019-03-15T17:56:41+01:00;
      };
    });

    # Fix prettier format command.
    format-all = super.format-all.overrideAttrs(attrs: {
      version = "20190206.1333";
      src = pkgs.fetchFromGitHub {
        owner = "lassik";
        repo = "emacs-format-all-the-code";
        rev = "3d0eda591bc22fad6cbea3f84c716ae2b7fb80e6";
        sha256 = "1k9m6lrp3d9msg7r88l9gkpiqj4w7aclnxqfw07cxhy9rzw5gwi3";
        # date = 2019-02-06T13:33:24+02:00;
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

    # Fix update at cursor position.
    nix-update = super.nix-update.overrideAttrs(attrs: {
      version = "20190124.1135";
      src = pkgs.fetchFromGitHub {
        owner = "jwiegley";
        repo = "nix-update-el";
        rev = "fc6c39c2da3fcfa62f4796816c084a6389c8b6e7";
        sha256 = "01cpl4w49m5dfkx7l8g1q183s341iz6vkjv2q4fbx93avd7msjgi";
        # date = 2019-01-24T11:35:44-08:00;
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

    # Include .nosearch file.
    realgud = super.realgud.overrideAttrs(attrs: {
      version = "20190121.1943";
      src = pkgs.fetchFromGitHub {
        owner = "realgud";
        repo = "realgud";
        rev = "1da5f2b5161bd5d5671b38ab182084e2d89e7c45";
        sha256 = "19ijc3v1wz01631hyc3x1bgx9kczhdzc99jlxxfq9y5yr8p1s2qa";
        # date = 2019-01-21T19:43:49-05:00;
      };

      recipe = pkgs.writeText "recipe" ''
        (realgud
        :fetcher github
        :repo "realgud/realgud"
        :files ("realgud.el" "realgud/.nosearch"
        ("realgud/common"             "realgud/common/*.el")
        ("realgud/common/buffer"      "realgud/common/buffer/*.el")
        ("realgud/debugger/bashdb"    "realgud/debugger/bashdb/*.el")
        ("realgud/debugger/gdb"       "realgud/debugger/gdb/*.el")
        ("realgud/debugger/gub"       "realgud/debugger/gub/*.el")
        ("realgud/debugger/ipdb"      "realgud/debugger/ipdb/*.el")
        ("realgud/debugger/jdb"       "realgud/debugger/jdb/*.el")
        ("realgud/debugger/kshdb"     "realgud/debugger/kshdb/*.el")
        ("realgud/debugger/nodejs"    "realgud/debugger/nodejs/*.el")
        ("realgud/debugger/pdb"       "realgud/debugger/pdb/*.el")
        ("realgud/debugger/perldb"    "realgud/debugger/perldb/*.el")
        ("realgud/debugger/rdebug"    "realgud/debugger/rdebug/*.el")
        ("realgud/debugger/remake"    "realgud/debugger/remake/*.el")
        ("realgud/debugger/trepan"    "realgud/debugger/trepan/*.el")
        ("realgud/debugger/trepan.pl" "realgud/debugger/trepan.pl/*.el")
        ("realgud/debugger/trepan2"   "realgud/debugger/trepan2/*.el")
        ("realgud/debugger/trepan3k"  "realgud/debugger/trepan3k/*.el")
        ("realgud/debugger/trepanjs"  "realgud/debugger/trepanjs/*.el")
        ("realgud/debugger/zshdb"     "realgud/debugger/zshdb/*.el")
        ("realgud/lang" "realgud/lang/*.el")))
       '';
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

    goto-line-preview = self.melpaBuild rec {
      pname   = "goto-line-preview";
      version = "20190308.1538";
      src = pkgs.fetchFromGitHub {
        owner  = "jcs090218";
        repo   = "goto-line-preview";
        rev    = "772fb942777a321b4698add1b94cff157f23a93b";
        sha256 = "16zil8kjv7lfmy11g88p1cm24j9db319fgkwzsgf2vzp1m15l0pc";
        # date = 2019-03-08T15:38:36+08:00;
      };
      recipe = pkgs.writeText "recipe" ''
        (goto-line-preview :repo "jcs090218/goto-line-preview" :fetcher github)
      '';

      meta = {
        description = "Preview line when executing goto-line command.";
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
      version = "20190303.0209";
      src = pkgs.fetchFromGitHub {
        owner  = "mpwang";
        repo   = "perfect-margin";
        rev    = "f3723f59cd56d22043a2ef31e4b2aed08c7add1f";
        sha256 = "108nj14cjcvz0yidsriirf0cyakdq6v0r5vap12k9nk85k9xwry2";
        # date = 2019-03-03T02:09:15+08:00;
      };
      recipe = pkgs.writeText "recipe" ''
        (perfect-margin :repo "mpwang/perfect-margin" :fetcher github)
      '';

      meta = {
        description = "Auto center emacs windows, work with minimap and/or linum-mode.";
      };
    };

    realgud-node-inspect = self.melpaBuild rec {
      pname = "realgud-node-inspect";
      version = "20190317.2230";
      src = pkgs.fetchFromGitHub {
        owner  = "terlar";
        repo   = "realgud-node-inspect";
        rev    = "284546506cc5f48f5c394661ed6498a3c3c53d1f";
        sha256 = "16yrk84d0si5yghsqxbnjy8gh27cwmra42d85mhas18xvyx5dm4k";
        # date = 2019-03-17T22:30:00+01:00;
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

    reformatter = self.melpaBuild rec {
      pname   = "reformatter";
      version = "20190222.1042";
      src = pkgs.fetchFromGitHub {
        owner  = "purcell";
        repo   = "reformatter.el";
        rev    = "028dae00dd9a9c0846f6a2c9251af7acf68e6ad3";
        sha256 = "0g3k8p6cysp3lx4ynd0df8d2vqxs3faanpmf4f10l2zm3z4bcz4g";
        # date = 2019-02-22T10:42:21+13:00;
      };
      recipe = pkgs.writeText "recipe" ''
        (reformatter :repo "purcell/reformatter.el" :fetcher github)
      '';

      meta = {
        description = "Define commands which run reformatters on the current Emacs buffer";
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

    undo-propose = self.melpaBuild rec {
      pname   = "undo-propose";
      version = "20190302.0820";
      src = pkgs.fetchFromGitHub {
        owner  = "jackkamm";
        repo   = "undo-propose-el";
        rev    = "503963cbe69197339cc6ab01a1b909590b433de7";
        sha256 = "1acz7lsbqcyn06r5zhp4qkqmwz282mjpwvj20q2nv5v8qkby2qic";
        # date = 2019-03-02T08:20:15-08:00;
      };
      recipe = pkgs.writeText "recipe" ''
        (undo-propose :repo "jackkamm/undo-propose-el" :fetcher github)
      '';

      meta = {
        description = "Navigate through your undo history in a temporary buffer.";
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
