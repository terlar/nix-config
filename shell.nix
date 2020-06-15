{ system ? builtins.currentSystem }:

(import ./compat.nix).devShell.${system}
