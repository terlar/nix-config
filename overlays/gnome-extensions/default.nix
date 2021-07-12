final: prev:

{
  gnomeExtensions = prev.gnomeExtensions // (with prev.gnome3; {
    paperwm = prev.gnomeExtensions.paperwm.overrideDerivation (old: {
      version = "pre-40.0";
      src = prev.fetchFromGitHub {
        owner = "paperwm";
        repo = "paperwm";
        rev = "10215f57e8b34a044e10b7407cac8fac4b93bbbc";
        sha256 = "0g335rcj6nq40kn9nklyv12arv7c4ds9l4q3id56c72ib5hfawfk";
      };
    });

    gtktitlebar = callPackage ../../pkgs/gnome-extensions/gtktitlebar { };
    invert-window = callPackage ../../pkgs/gnome-extensions/invert-window { };
    miniview = callPackage ../../pkgs/gnome-extensions/miniview { };
    switcher = callPackage ../../pkgs/gnome-extensions/switcher { };
  });
}
