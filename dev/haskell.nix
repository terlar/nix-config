{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ghc
    stack

    haskellPackages.hlint
    haskellPackages.structured-haskell-mode
    haskellPackages.stylish-haskell
    haskellPackages.intero
  ];
}
