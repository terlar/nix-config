final: prev:

let packageOverrides = import ../pkgs/python-packages;
in { python3 = prev.python3.override { inherit packageOverrides; }; }
