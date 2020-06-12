{ lib, buildPythonPackage, fetchPypi, requests, botocore, mock }:

buildPythonPackage rec {
  pname = "aws-requests-auth";
  version = "0.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "112c85fe938a01e28f7e1a87168615b6977b28596362b1dcbafbf4f2cc69f720";
  };

  propagatedBuildInputs = [ requests botocore ];
  checkInputs = [ mock ];

  meta = with lib; {
    homepage = "https://github.com/DavidMuller/aws-requests-auth";
    description =
      "AWS signature version 4 signing process for the python requests module.";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
