self: super:

{
  # https://github.com/NixOS/nixpkgs/issues/44426
  python27 = super.python27.override { packageOverrides = self.pythonOverrides; };
  python35 = super.python35.override { packageOverrides = self.pythonOverrides; };
  python36 = super.python36.override { packageOverrides = self.pythonOverrides; };
  python37 = super.python37.override { packageOverrides = self.pythonOverrides; };

  pythonOverrides = import ./python-packages;
}
