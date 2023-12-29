_final: prev: {
  iosevka-slab = prev.callPackage ./iosevka-slab {};
  project-init = prev.callPackage ./project-init {};
  saw = prev.callPackage ./saw {};
  themepark = prev.callPackage ./themepark {};

  gnome =
    prev.gnome
    // {
      gnome-keyring = prev.gnome.gnome-keyring.overrideAttrs (old: {
        configureFlags = old.configureFlags ++ ["--disable-ssh-agent"];
      });
    };
}
