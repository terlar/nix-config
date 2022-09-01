final: prev:

{
  gnupg = prev.gnupg.overrideAttrs (old:
    if old.version == "2.3.7" then {
      patches = old.patches ++ [
        (final.fetchpatch {
          name = "fix-yubikey.patch";
          url =
            "https://files.gnupg.net/file/data/io6l7fvfebflbqm44ll3/PHID-FILE-7ppyegfowo5do2d6izc4/file";
          sha256 = "sha256-J/PLSz8yiEgtGv+r3BTGTHrikV70AbbHQPo9xbjaHFE=";
        })
      ];
    } else
      { });
}
