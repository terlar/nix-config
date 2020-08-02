final: prev:

{
  gnomeExtensions = prev.gnomeExtensions // (with prev.gnome3; {
    gtktitlebar = callPackage ../../pkgs/gnome-extensions/gtktitlebar { };
    switcher = callPackage ../../pkgs/gnome-extensions/switcher { };
    invert-window = callPackage ../../pkgs/gnome-extensions/invert-window { };
  });
}
