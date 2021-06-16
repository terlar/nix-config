final: prev:

{
  iosevka-slab = prev.iosevka.override {
    set = "slab";
    privateBuildPlan = {
      family = "Iosevka Slab";
      spacing = "fontconfig-mono";
      serifs = "slab";

      variants.design = {
        asterisk = "hex-low";
        at = "threefold";
        caret = "low";
        dollar = "open";
        paragraph-sign = "low";
        underscore = "low";
        zero = "dotted";
      };
    };
  };
}
