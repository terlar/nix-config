self: super:

with builtins;
with super.stdenv.lib;

let
  packageOverrides = import ../pkgs/python-packages;
in {
  python3 = super.python3.override { inherit packageOverrides; };
}
