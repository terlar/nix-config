self: pkgs:

{
  emacsPackagesOverrides = super: self: with self; let
    inherit (pkgs.stdenv) mkDerivation lib;
    inherit (pkgs) fetchurl fetchgit fetchFromGitHub;
    inherit (pkgs) writeText;
  in {
    # Fix conflict with wdired.
    all-the-icons-dired = all-the-icons-dired.overrideAttrs(attrs: {
      patches = [ ./patches/all-the-icons-dired.patch ];
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
    in self.elpaBuild rec {
      inherit (jsonrpc) pname ename version meta;
      src = patchedSrc;
      packageRequires = [ super.emacs ];
    };

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
      name = "emacs-org-${version}";
      version = "20200201.1122";

      src = fetchgit {
        url = https://code.orgmode.org/terlar/org-mode.git;
        rev = "55953033962b72b49b974e2e58fc2063bf47ba71";
        sha256 = "1wcbq5ah1dxy70ld8d2djfmr70986r875lyanp4d40rv3agxs4wd";
        # date = 2020-02-01T11:22:03+01:00;
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
        license = lib.licenses.free;
      };
    };

    # Packages not in MELPA.
    apheleia = self.melpaBuild rec {
      pname   = "apheleia";
      version = "20200102.1130";
      src = fetchFromGitHub {
        owner  = "raxod502";
        repo   = "apheleia";
        rev    = "179219e619ebaa095760e2a92ef57bb3a28869bc";
        sha256 = "0zwjcgb4n9nay7c6wdrmxqx73nshr2is1ymdc4wd1bd49sb5481i";
        # date = 2020-01-02T11:30:45-07:00;
      };
      recipe = writeText "recipe" ''(${pname} :repo "x" :fetcher github)'';
    };

    eglot-x = self.melpaBuild rec {
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

    ejira = self.melpaBuild rec {
      pname   = "ejira";
      version = "20191114.2121";
      src = fetchFromGitHub {
        owner  = "nyyManni";
        repo   = "ejira";
        rev    = "6f1c211a2a997187eecb90603c72f16eb6c6d77d";
        sha256 = "1mz145nki5i8clnfmvc7ikk1jnq4058bhaxnjydbddnxk2c411ir";
        # date = 2019-11-14T21:21:21+02:00;
      };
      recipe = writeText "recipe" ''(${pname} :repo "x" :fetcher github) '';
      packageRequires = [ self.s self.f self.ox-jira self.dash self.jiralib2 self.language-detection ];
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
      recipe = writeText "recipe" ''(${pname} :repo "x" :fetcher github) '';
    };

    ivy-ghq = self.melpaBuild rec {
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
      recipe = writeText "recipe" ''(${pname} :repo "x" :fetcher github)'';
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
      recipe = writeText "recipe" ''(${pname} :repo "x" :fetcher github)'';
    };
  };
}
