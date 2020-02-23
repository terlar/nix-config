{ pkgs ? import <nixpkgs> {} }:

let
  self = import ./all-packages.nix self;
in self pkgs
