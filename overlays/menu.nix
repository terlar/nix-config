self: pkgs:

let
  drv = pkgs.fetchFromGitHub {
    owner = "terlar";
    repo = "menu";
    rev = "a35743c7b6bcac7f829dc15678ee7e2385cb2330";
    # date = 2019-12-04T00:39:29+01:00;
    sha256 = "1s66wdnv8zbncyixc8dpz0zxj0xazkgdq3zj5hlg8xhgp0w56476";
  };
in {
  menu = pkgs.callPackage drv { };
}
