{ stdenv, buildGoPackage, fetchgit }:

buildGoPackage rec {
  pname = "hey";
  version = "0.1.3";

  goPackagePath = "github.com/rakyll/hey";
  goDeps = ./deps.nix;

  src = fetchgit {
    url = https://github.com/rakyll/hey.git;
    rev = "v${version}";
    sha256 = "06w5hf0np0ayvjnfy8zgy605yrs5j326nk2gm0fy7amhwx1fzkwv";
  };

  meta = with stdenv.lib; {
    description = "HTTP load generator, ApacheBench (ab) replacement, formerly known as rakyll/boom.";
    homepage = https://github.com/rakyll/hey;
    license = licenses.asl20;
    maintainers = with maintainers; [ terlar ];
  };
}
