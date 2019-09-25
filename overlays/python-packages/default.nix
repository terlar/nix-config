self: super:

{
  aws-requests-auth = super.pythonPackages.callPackage ../../packages/aws-requests-auth { };
  screeninfo = super.pythonPackages.callPackage ../../packages/screeninfo { };
}
