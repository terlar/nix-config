self: super:

{
  scripts = {
    lock = super.callPackage ../packages/lock { };
    logout = super.callPackage ../packages/logout { };
  };
}
