{ config, pkgs, ... }:

{
  imports = [
    ./dev/bash.nix
    ./dev/crystal.nix
    ./dev/elixir.nix
    ./dev/elm.nix
    ./dev/erlang.nix
    ./dev/go.nix
    ./dev/haskell.nix
    ./dev/java.nix
    ./dev/javascript.nix
    ./dev/kotlin.nix
    ./dev/lua.nix
    ./dev/python.nix
    ./dev/racket.nix
    ./dev/ruby.nix
    ./dev/rust.nix
    ./dev/scala.nix
  ];

  boot.extraModulePackages = [ config.boot.kernelPackages.sysdig ];

  environment.systemPackages = with pkgs; [
    nix-repl
    editorconfig-core-c
    exercism
    sysdig
    clang gcc ncurses
    gdb
    binutils
    global
    httpie
    jq
    plantuml
    python3Packages.pygments
    python3Packages.yamllint
    awscli
    pssh
    ttyrec
    ansible salt packer
  ];
}
