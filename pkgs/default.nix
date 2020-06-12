final: prev:

{
  scripts = {
    insomnia = prev.callPackage ./scripts/insomnia { };
    lock = prev.callPackage ./scripts/lock { };
    logout = prev.callPackage ./scripts/logout { };
    themepark = prev.callPackage ./scripts/themepark { };
    window_tiler = prev.callPackage ./scripts/window_tiler { };
  };

  gore = prev.callPackage ./gore { };
  hey = prev.callPackage ./hey { };
  kmonad-bin = prev.callPackage ./kmonad-bin { };
  rufo = prev.callPackage ./rufo { };
  saw = prev.callPackage ./saw { };
}
