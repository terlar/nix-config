{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "saw";
  version = "0.2.2";

  goPackagePath = "github.com/TylerBrock/saw";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "TylerBrock";
    repo = "saw";
    rev = "v${version}";
    sha256 = "0hf4dzlkcxl09xvhpg1h0hp51cnq10396plyb518m9lrpr8x6l4z";
  };

  meta = with lib; {
    description = "Fast, multi-purpose tool for AWS CloudWatch Logs.";
    homepage = "https://github.com/TylerBrock/saw";
    license = licenses.mit;
    maintainers = with maintainers; [ terlar ];
  };
}
