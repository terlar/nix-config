final: prev:

{
  scripts = {
    insomnia = prev.callPackage ./scripts/insomnia { };
    lock = prev.callPackage ./scripts/lock { };
    logout = prev.callPackage ./scripts/logout { };
    themepark = prev.callPackage ./scripts/themepark { };
  };

  rufo = prev.callPackage ./rufo { };
  saw = prev.callPackage ./saw { };
}
