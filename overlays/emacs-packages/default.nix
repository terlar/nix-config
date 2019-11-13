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

    # Fix recursive loop when used together with Emacs 27.
    seq = let
      src = seq.src;
      patchedSrc = mkDerivation {
        name = "emacs-${seq.pname}-${seq.version}-patched.tar";
        inherit src;
        phases = [ "unpackPhase" "patchPhase" ];
        patches = [ ./patches/seq.patch ];
        postPatch = "tar -C .. -cf $out $sourceRoot";
      };
    in self.elpaBuild rec {
      inherit (seq) pname ename version meta;
      src = patchedSrc;
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
      version = "20191108.1158";

      src = fetchgit {
        url = https://code.orgmode.org/terlar/org-mode.git;
        rev = "fbe245c0b09513ee5a6d3b189e112708b9d08da0";
        sha256 = "0p6f32cp650j97c5x7cvg05lld7hsj7fcsz44frqd6p5gf445b6y";
        # date = 2019-11-08T11:58:25+01:00;
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
      version = "20190310.2029";
      src = fetchFromGitHub {
        owner  = "analyticd";
        repo   = "ivy-ghq";
        rev    = "fe7e722335676d5a2277a9c33e6796f7f46d84d8";
        sha256 = "1hvw05v563njadqlj87dywvr086h77zg6hgysyl22x5vb4727zvw";
        # date = 2019-03-10T20:29:01-07:00;
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
