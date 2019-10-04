self: super:

{
  scripts = {
    emacseditor = super.callPackage ../packages/emacseditor { };
    insomnia = super.callPackage ../packages/insomnia { };
    lock = super.callPackage ../packages/lock { };
    logout = super.callPackage ../packages/logout { };
    window_tiler = super.callPackage ../packages/window_tiler { };
  };
}
