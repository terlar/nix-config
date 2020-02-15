self: pkgs:

{
  fwupd = pkgs.fwupd.overrideAttrs(attrs: rec {
    version = "1.3.8";

    src = pkgs.fetchurl {
      url = "https://people.freedesktop.org/~hughsient/releases/fwupd-${version}.tar.xz";
      sha256 = "14hbwp3263n4z61ws62vj50kh9a89fz2l29hyv7f1xlas4zz6j8x";
    };

    patches = attrs.patches ++ [
      # Find the correct lds and crt name when specifying -Defi_ldsdir
      (pkgs.fetchpatch {
        url = "https://github.com/fwupd/fwupd/commit/52cda3db9ca9ab4faf99310edf29df926a713b5c.patch";
        sha256 = "0hsj79dzamys7ryz33iwxwd58kb1h7gaw637whm0nkvzkqq6rm16";
      })
    ];
  });
}
