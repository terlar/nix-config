final: prev:

{
  nix-diff = prev.nix-diff.overrideAttrs (attrs:
    let
      inherit (attrs.passthru) pname version;
      revision = "1";
      newCabalFileUrl = "mirror://hackage/${pname}-${version}/revision/${revision}.cabal";
      newCabalFile = prev.fetchurl {
        url = newCabalFileUrl;
        sha256 = "1537zp48kj7xvar70dx817j8r8prcj6vr2m0ckfl6gsxziq6hrkp";
        name = "${pname}-${version}-r${revision}.cabal";
      };
    in
    {
      prePatch = ''
        echo "Replace Cabal file with edited version from ${newCabalFileUrl}."
        cp ${newCabalFile} ${pname}.cabal
      '' + attrs.prePatch;
    });
}
