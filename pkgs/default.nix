self: pkgs:

{
  scripts = {
    emacseditor = pkgs.callPackage ./scripts/emacseditor { };
    emacsmail = pkgs.callPackage ./scripts/emacsmail { };
    insomnia = pkgs.callPackage ./scripts/insomnia { };
    lock = pkgs.callPackage ./scripts/lock { };
    logout = pkgs.callPackage ./scripts/logout { };
    themepark = pkgs.callPackage ./scripts/themepark { };
    window_tiler = pkgs.callPackage ./scripts/window_tiler { };
  };

  gore = pkgs.callPackage ./gore { };
  hey = pkgs.callPackage ./hey { };
  kmonad-bin = pkgs.callPackage ./kmonad-bin { };
  saw = pkgs.callPackage ./saw { };
}
