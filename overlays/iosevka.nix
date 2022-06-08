final: prev:

{
  iosevka-slab = prev.iosevka.override {
    set = "slab";
    privateBuildPlan = {
      family = "Iosevka Slab";
      spacing = "fontconfig-mono";
      serifs = "slab";

      variants.design = {
        zero = "dotted";
        asterisk = "hex-low";
        underscore = "low";
        pilcrow = "low";
        caret = "low";
        paren = "large-contour";
        brace = "straight";
        number-sign = "upright-tall";
        at = "fourfold-tall";
        dollar = "interrupted";
        percent = "rings-continuous-slash";
        question = "corner";
      };

      ligations = {
        inherits = "dlig";
      };
    };
  };
}
