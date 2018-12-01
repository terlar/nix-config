{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    python
    python27Packages.pip
    python36Packages.pip
    python27Packages.black
    python36Packages.black
    python27Packages.flake8
    python36Packages.flake8
    python27Packages.pytest
    python36Packages.pytest
  ];
}
