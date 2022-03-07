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
        at = "fourfold";
        caret = "low";
        dollar = "open";
        pilcrow = "low";
        underscore = "low";
        zero = "dotted";
      };
    };
  };
}
