{ system ? builtins.currentSystem }:

let flake = builtins.getFlake (toString ./.); in
{
  inherit flake system;
  inherit (flake.inputs.nixpkgs) lib;
  pkgs = import flake.inputs.nixpkgs {
    inherit system;
    overlays = [ flake.overlay ];
  };
}
