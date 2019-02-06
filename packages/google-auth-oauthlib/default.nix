{ lib, python37Packages, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "google-auth-oauthlib";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "226d1d0960f86ba5d9efd426a70b291eaba96f47d071657e0254ea969025728a";
  };

  meta = with lib; {
    homepage = https://github.com/GoogleCloudPlatform/google-auth-library-python-oauthlib;
    description = "Google Authentication Library";
    license = licenses.apache2;
    platforms = platforms.all;
  };

  checkInputs = with python37Packages; [
    click
    mock
    pytest
  ];

  propagatedBuildInputs = with python37Packages; [
    google_auth
    requests_oauthlib
  ];

  doCheck = false;
}
