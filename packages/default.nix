_final: prev: {
  scripts = {
    insomnia = prev.callPackage ./scripts/insomnia {};
    lock = prev.callPackage ./scripts/lock {};
    logout = prev.callPackage ./scripts/logout {};
    themepark = prev.callPackage ./scripts/themepark {};
  };

  iosevka-slab = prev.callPackage ./iosevka-slab {};
  project-init = prev.callPackage ./project-init {};
  saw = prev.callPackage ./saw {};
  jfrog-cli = prev.callPackage ./jfrog-cli {};
}
