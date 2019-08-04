self: super:

{
  aws-requests-auth = super.pythonPackages.callPackage ../../packages/aws-requests-auth { };
  httpie-aws-authv4 = super.pythonPackages.callPackage ../../packages/httpie-aws-authv4 { };
  screeninfo = super.pythonPackages.callPackage ../../packages/screeninfo { };
}
