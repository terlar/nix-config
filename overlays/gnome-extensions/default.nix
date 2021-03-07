final: prev:

{
  gnomeExtensions = prev.gnomeExtensions // (with prev.gnome3; {
    gtktitlebar = callPackage ../../pkgs/gnome-extensions/gtktitlebar { };
    invert-window = callPackage ../../pkgs/gnome-extensions/invert-window { };
    miniview = callPackage ../../pkgs/gnome-extensions/miniview { };
    switcher = callPackage ../../pkgs/gnome-extensions/switcher { };
  });
}
