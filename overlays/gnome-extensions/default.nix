final: prev:

with prev;
with gnomeExtensions;

{
  gnomeExtensions = gnomeExtensions // {
    gtktitlebar = final.callPackage ../../pkgs/gnome-extensions/gtktitlebar { };
    switcher = final.callPackage ../../pkgs/gnome-extensions/switcher { };
  };
}
