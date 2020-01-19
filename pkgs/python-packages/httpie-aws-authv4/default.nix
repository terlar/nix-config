{ lib, buildPythonPackage, fetchPypi, httpie, aws-requests-auth, boto3, urllib3 }:

buildPythonPackage rec {
  pname = "httpie-aws-authv4";
  version = "0.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f9c54c0386c0c30220065812a4538bc83f1c314a1df24aba9a3ddc23ad714ebd";
  };

  propagatedBuildInputs = [ httpie aws-requests-auth boto3 urllib3 ];

  meta = with lib; {
    homepage = https://github.com/aidan-/httpie-aws-authv4;
    description = "AWS auth v4 plugin for HTTPie.";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
