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
      version = "20191124.2339";

      src = fetchgit {
        url = https://code.orgmode.org/terlar/org-mode.git;
        rev = "5f3b98944ab9775c72d12fd37bd60d4ff7c0ea96";
        sha256 = "01jf3zk3nkgfqis8mmagigpgcmibdcnjcjbb7bqcpbrg1hsfiy7y";
        # date = 2019-12-01T20:58:15+01:00;
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

    org-variable-pitch = org-variable-pitch.overrideAttrs(attrs: {
      version = "20191206.1519";
      src = fetchFromGitHub {
        owner = "terlar";
        repo = "elisp";
        rev = "8a926d6f6efc4edf878d636497d37daf41b3a001";
        sha256 = "0m0ikyw36bivsr0f3wwqsn8i3kzck0vg98gb0sv2n17xpfi387qm";
        # date = 2019-12-06T15:19:36+01:00;
      };
    });

    # Packages not in MELPA.
    apheleia = self.melpaBuild rec {
      pname   = "apheleia";
      version = "20191116.2205";
      src = fetchFromGitHub {
        owner  = "raxod502";
        repo   = "apheleia";
        rev    = "61f9335756bbc2102e4c91cb3f5361891c74f27c";
        sha256 = "0i5i9z6grr7nzxs94xbgb9mf4qirj1lcdqhl698p0rj1097yny7q";
        # date = 2019-11-16T22:05:28-08:00;
      };
      recipe = writeText "recipe" ''
        (apheleia :repo "raxod502/apheleia" :fetcher github)
      '';

      meta = {
        description = "Run code formatter on buffer contents without moving point, using RCS patches and dynamic programming.";
      };
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
      recipe = writeText "recipe" ''
        (ejira :repo "nyyManni/ejira" :fetcher github)
      '';
      packageRequires = [ self.s self.f self.ox-jira self.dash self.jiralib2 self.language-detection ];

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

    ivy-ghq = self.melpaBuild rec {
      pname   = "ivy-ghq";
      version = "20191123.655";
      src = fetchFromGitHub {
        owner  = "analyticd";
        repo   = "ivy-ghq";
        rev    = "b0c05b91e2098233aa7fac7fad9d39f78146d44b";
        sha256 = "0hvhbkgxbb9arxcpz3nyyc0176hzg0j5538vmvl2ybjxcalls5jy";
        # date = 2019-11-23T06:55:02-08:00;
      };
      recipe = writeText "recipe" ''
        (ivy-ghq :repo "analyticd/ivy-ghq" :fetcher github)
      '';

      meta = {
        description = "Navigate to ghq managed git repos quickly using ivy Emacs package.";
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
}
