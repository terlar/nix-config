self: super:

let
  version = "1.0";
  drv = builtins.fetchGit {
    name = "menu-${version}";
    url = "https://github.com/terlar/menu.git";
    ref = version;
    rev = "788606203fb7661e00580ef4a84057cebceede7d";
  };
in {
  menu = super.callPackage drv { };
}
