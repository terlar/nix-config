self: super:

{
  scripts = {
    emacseditor = super.callPackage ./scripts/emacseditor { };
    emacsmail = super.callPackage ./scripts/emacsmail { };
    insomnia = super.callPackage ./scripts/insomnia { };
    lock = super.callPackage ./scripts/lock { };
    logout = super.callPackage ./scripts/logout { };
    themepark = super.callPackage ./scripts/themepark { };
    window_tiler = super.callPackage ./scripts/window_tiler { };
  };

  gore = super.callPackage ./gore { };
  hey = super.callPackage ./hey { };
  saw = super.callPackage ./saw { };
}
