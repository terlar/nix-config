final: prev:

{
  iosevka-slab = prev.iosevka.override {
    privateBuildPlan = {
      family = "Iosevka Slab";
      design = [
        "slab"
        "ligset-hskl"
        "calt-exeq-alt-1"
        "calt-html-comment"
        "calt-tildeeq"
        "v-asterisk-low"
        "v-at-long"
        "v-caret-low"
        "v-dollar-open"
        "v-paragraph-low"
        "v-underscore-low"
        "v-zero-dotted"
      ];
    };
    set = "slab";
  };
}
