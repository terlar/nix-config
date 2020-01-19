self: super:

{
  aws-requests-auth = super.pythonPackages.callPackage ./aws-requests-auth { };
  screeninfo = super.pythonPackages.callPackage ./screeninfo { };
}
