final: prev:

{
  iosevka-slab = prev.iosevka.override {
    set = "slab";
    privateBuildPlan = {
      family = "Iosevka Slab";
      spacing = "normal";
      serifs = "slab";

      variants.design = {
        asterisk = "low";
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
