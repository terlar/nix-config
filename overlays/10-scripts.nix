self: super:

{
  scripts = {
    emacseditor = super.callPackage ../packages/emacseditor { };
    lock = super.callPackage ../packages/lock { };
    logout = super.callPackage ../packages/logout { };
    window_tiler = super.callPackage ../packages/window_tiler { };
  };
}
