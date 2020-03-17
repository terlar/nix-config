self: pkgs:

let
  inherit (pkgs.stdenv) mkDerivation lib;
  inherit (pkgs) fetchpatch fetchFromGitHub writeText;
in {
  emacsPackageOverrides = eSelf: eSuper: with eSuper; {
    # Load direnv before dir-locals.
    direnv = direnv.overrideAttrs(attrs: {
      patches = [
        (fetchpatch {
          name = "load-direnv-before-dir-locals.patch";
          url = https://github.com/wbolster/emacs-direnv/commit/bb7dce0a7708b281ffbe30eed854a192c7f0ed78.patch;
          sha256 = "1vwi2dnj9dyf057mjqisc0hn6n0diprbsp9d5pg8lc0fyn2g7sws";
        })
      ];
    });

    # Fix code actions when using javascript-typescript-langserver.
    jsonrpc = let
      src = jsonrpc.src;
      patch = ./patches/jsonrpc.patch;
      patchedSrc = mkDerivation {
        name = "emacs-${jsonrpc.pname}-${jsonrpc.version}-patched.el";
        inherit src;
        phases = [ "patchPhase" ];
        patchPhase = "patch $src -o $out < ${patch}";
      };
    in elpaBuild rec {
      inherit (jsonrpc) pname ename version meta;
      src = patchedSrc;
      packageRequires = [ emacs ];
    };

    # Add nix support.
    separedit = separedit.overrideAttrs(attrs: {
      patches = [
        (fetchpatch {
          name = "separedit-nix-mode-support.patch";
          url = https://github.com/twlz0ne/separedit.el/commit/915a8f946d821e2f0eae2e8b5ee95f29085a6052.patch;
          sha256 = "0wcnbyaqflqvpk0z63km93w5s5g7zq0zxpmrxcwkca1y92qmqizc";
        })
      ];
    });

    # Personal forks.
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
      pname = "emacs-org";
      version = "20200307.730";

      src = fetchFromGitHub {
        owner = "terlar";
        repo = "org-mode";
        rev = "d2622db2aa7ec61850d167fde17d56af23455c83";
        sha256 = "1yygls4r6p2v7dmbz91yf01fscww89g9idw9myk20r5vrcwj1p7s";
        # date = 2020-03-07T07:30:09+01:00;
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

      buildInputs = [ emacs pkgs.texinfo pkgs.perl pkgs.which ];

      meta = {
        homepage = "https://elpa.gnu.org/packages/org.html";
        license = lib.licenses.free;
      };
    };

    # Packages not in MELPA.
    apheleia = melpaBuild rec {
      pname   = "apheleia";
      version = "20200219.2247";
      src = fetchFromGitHub {
        owner  = "raxod502";
        repo   = "apheleia";
        rev    = "8e99a67cc185db01298a282e0d24277249bcfab8";
        sha256 = "02np55c32jy5j7s0qkmrb1qggh4r05y12k10pwd88hl8y64sp35c";
        # date = 2020-02-19T22:47:09-08:00;
      };
      recipe = writeText "recipe" ''(${pname} :repo "x" :fetcher github)'';
    };

    eglot-x = melpaBuild rec {
      pname   = "eglot-x";
      version = "20200104.1435";
      src = fetchFromGitHub {
        owner  = "nemethf";
        repo   = "eglot-x";
        rev    = "910848d8d6dde3712a2a2610c00569c46614b1fc";
        sha256 = "0sl6k5y3b855mbix310l9xzwqm4nb8ljjq4w7y6r1acpfwd7lkdc";
        # date = 2020-01-04T14:35:35+01:00;
      };
      recipe = writeText "recipe" ''(${pname} :repo "x" :fetcher github)'';
    };

    ejira = melpaBuild rec {
      pname   = "ejira";
      version = "20200206.2144";
      src = fetchFromGitHub {
        owner  = "nyyManni";
        repo   = "ejira";
        rev    = "89f7c668caf0e46e929f2c9187b007eed6b5c229";
        sha256 = "0a97gx016byiy5fri8jf3x3sfd2h2iw79s6nxv9jigpkgxrkjg7b";
        # date = 2020-02-06T21:44:57+02:00;
      };
      recipe = writeText "recipe" ''(${pname} :repo "x" :fetcher github) '';
      packageRequires = [ org s f ox-jira dash jiralib2 language-detection ];
    };

    eldoc-posframe = melpaBuild rec {
      pname   = "eldoc-posframe";
      version = "20190209.1123";
      src = fetchFromGitHub {
        owner  = "terlar";
        repo   = "eldoc-posframe";
        rev    = "2e012a097dfab66a05a858b1486bba9f70956823";
        sha256 = "1pn1g8mwcgxpavwj9z8rr244pak3n7jqbswjav5bni89s4wm9rhz";
        # date = 2019-02-09T11:23:21+01:00;
      };
      recipe = writeText "recipe" ''(${pname} :repo "x" :fetcher github) '';
    };

    ivy-ghq = melpaBuild rec {
      pname   = "ivy-ghq";
      version = "20191231.1957";
      src = fetchFromGitHub {
        owner  = "analyticd";
        repo   = "ivy-ghq";
        rev    = "78a4cd32a7d7556c7c987b0089ea354e41b6f901";
        sha256 = "1ddpdhg26nhqdd30k36c3mkciv5k2ca7vqmy3q855qnimir97zxz";
        # date = 2019-12-31T19:57:04-08:00;
      };
      recipe = writeText "recipe" ''(${pname} :repo "x" :fetcher github)'';
    };

    org-pretty-table = melpaBuild rec {
      pname   = "org-pretty-table";
      version = "20131129.1610";
      src = fetchFromGitHub {
        owner  = "fuco1";
        repo   = "org-pretty-table";
        rev    = "0dca6f3156dd1eb0a42f08ac2ad89259637a16b5";
        sha256 = "09avbl1mmgs3b1ya0rvv9kswq2k7d133zgr18cazl3jkpvh35lxg";
        # date = 2013-11-29T16:10:09+01:00;
      };
      recipe = writeText "recipe" ''(${pname} :repo "x" :fetcher github)'';
    };

    source-peek = melpaBuild rec {
      pname   = "source-peek";
      version = "20170424.347";
      src = fetchFromGitHub {
        owner  = "iqbalansari";
        repo   = "emacs-source-peek";
        rev    = "fa94ed1def1e44f3c3999d355599d1dd9bc44dab";
        sha256 = "14ai66c7j2k04a0vav92ybaikcc8cng5i5vy0iwpg7b2cws8a2zg";
        # date = 2017-04-24T03:47:10+05:30;
      };
      recipe = writeText "recipe" ''(${pname} :repo "x" :fetcher github)'';
    };
  };
}
