final: prev:

with prev;
with gnomeExtensions;

{
  gnomeExtensions = gnomeExtensions // (with final.gnome3; {
    gtktitlebar = callPackage ../../pkgs/gnome-extensions/gtktitlebar { };
    switcher = callPackage ../../pkgs/gnome-extensions/switcher { };
    invert-window = callPackage ../../pkgs/gnome-extensions/invert-window { };
  });
}
