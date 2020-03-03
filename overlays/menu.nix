self: pkgs:

let
  drv = pkgs.fetchFromGitHub {
    owner = "terlar";
    repo = "menu";
    rev = "77c6950e4728f9b5584936f2cbff7d92a5c64442";
    # date = 2020-03-03T18:03:33+01:00;
    sha256 = "1r4aibj94bhf9k4sg12ql7jc80g46qnz216kakcncknwfjc4wqq3";
  };
in {
  menu = pkgs.callPackage drv { };
}
