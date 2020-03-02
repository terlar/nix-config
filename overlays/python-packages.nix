self: super:

with builtins;
with super.stdenv.lib;

let
  packageOverrides = import ../pkgs/python-packages;
  python3s = filterAttrs (n: v: match "python[3][0-9]" n != null) super;
in mapAttrs (n: v: v.override { inherit packageOverrides; }) python3s
