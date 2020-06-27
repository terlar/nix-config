final: prev:

{
  scripts = {
    insomnia = prev.callPackage ./scripts/insomnia { };
    lock = prev.callPackage ./scripts/lock { };
    logout = prev.callPackage ./scripts/logout { };
    themepark = prev.callPackage ./scripts/themepark { };
    window_tiler = prev.callPackage ./scripts/window_tiler { };
  };

  google-chrome-beta-with-pipewire =
    prev.callPackage ./google-chrome-with-pipewire {
      google-chrome = final.google-chrome-beta;
      pipewire = final.pipewire_0_2;
    };
  google-chrome-dev-with-pipewire =
    prev.callPackage ./google-chrome-with-pipewire {
      google-chrome = final.google-chrome-dev;
      pipewire = final.pipewire_0_2;
    };
  kmonad-bin = prev.callPackage ./kmonad-bin { };
  rufo = prev.callPackage ./rufo { };
  saw = prev.callPackage ./saw { };
}
