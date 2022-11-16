{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "jfrog-cli";
  version = "2.29.2";

  src = fetchFromGitHub {
    owner = "jfrog";
    repo = "jfrog-cli";
    rev = "v${version}";
    hash = "sha256-E7bajdWBBlqSV76on3M9DLtm0R1WE1mRVKDSo/y+6E0=";
  };

  CGO_ENABLED = 0;

  vendorSha256 = "sha256-QLqAbIyudQzav5vmUpLRlDuFJF+DqDZzm+f6KGThjlk=";

  ldflags = [
    "-extldflags '-static'"
    "-s"
    "-w"
  ];

  # Most of them seem to require network access.
  doCheck = false;

  postInstall = ''
    ln -s $out/bin/jfrog-cli $out/bin/jf
  '';

  meta = with lib; {
    description = "A client that provides a simple interface that automates access to the JFrog products";
    homepage = "https://github.com/jfrog/jfrog-cli";
    license = licenses.asl20;
    maintainers = with maintainers; [terlar];
  };
}
