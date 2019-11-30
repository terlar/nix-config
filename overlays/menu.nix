self: pkgs:

let
  drv = pkgs.fetchFromGitHub {
    owner = "terlar";
    repo = "menu";
    rev = "cb2a77f10f55f90021fbfb940cc000df2a63f989";
    # date = 2019-11-30T19:15:17+01:00;
    sha256 = "1h77w3cv2f12ih9sm8plzi53hyc05zx4spacbd8mc3gaa8k8md67";
  };
in {
  menu = pkgs.callPackage drv { };
}
