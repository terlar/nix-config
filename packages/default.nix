_final: prev: {
  iosevka-slab = prev.callPackage ./iosevka-slab {};

  thermald = prev.thermald.overrideAttrs (old: {
    patches =
      (old.patches or [])
      ++ [
        (prev.fetchpatch {
          url = "https://patch-diff.githubusercontent.com/raw/intel/thermal_daemon/pull/422.patch";
          hash = "sha256-SDZBGVFAU8PYWfIkqLqprXrFfkympf9wg6elEugFk/g=";
        })
      ];
  });
}
