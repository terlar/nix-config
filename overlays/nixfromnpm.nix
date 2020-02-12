self: pkgs:

let
  drv = pkgs.fetchFromGitHub {
    owner = "adnelson";
    repo = "nixfromnpm";
    rev = "4ab773cdead920d2312e864857fabaf5f739a80e";
    # date = 2019-03-21T08:09:08-05:00;
    sha256 = "108qrfmv31xm22a1swrxzl5p0yfzzxf5hfhk9ih0ca07cyr8s2aw";
  };
in {
  nixfromnpm = pkgs.haskellPackages.callPackage drv {};
}
