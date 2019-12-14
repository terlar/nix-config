{ config, pkgs, lib, ... }:

let
  darwinConfigPath = ./darwin.nix;
  darwinPath = ../darwin;
  homeManagerConfigPath = ./home.nix;
  homeManagerPath = ../home-manager;
  nixPkgsPath = ../nixpkgs;
  nixPkgsOverlaysPath = ../overlays;
  nixosConfigPath = ../configuration.nix;
  privateDataPath = ../private/data.nix;
in {
  time.timeZone = "Europe/Stockholm";

  nixpkgs.config = import ./nixpkgs.nix;
  nixpkgs.overlays = map
    (n: import (nixPkgsOverlaysPath + ("/" + n)))
    (builtins.filter
      (n: builtins.match
        ".*\\.nix" n != null || builtins.pathExists (nixPkgsOverlaysPath + ("/" + n + "/default.nix")))
      (lib.attrNames (builtins.readDir nixPkgsOverlaysPath)));

  environment = {
    systemPackages = import ./packages.nix { inherit pkgs; };

    shells = [ pkgs.fish ];

    variables = {
      HOME_MANAGER_CONFIG = toString homeManagerConfigPath;

      LC_CTYPE    = "en_US.UTF-8";
      LESSCHARSET = "utf-8";
      PAGER       = "less";
      SHELL       = "${pkgs.fish}/bin/fish";
    };
  };

  nix = {
    package = pkgs.nixStable;
    nixPath = [
      "nixpkgs=${toString nixPkgsPath}"
      "nixpkgs-overlays=${toString nixPkgsOverlaysPath}"
      "home-manager=${toString homeManagerPath}"
      "private-data=${toString privateDataPath}"
    ] ++ lib.optionals pkgs.stdenv.isLinux [
      "nixos-config=${toString nixosConfigPath}"
    ] ++ lib.optionals pkgs.stdenv.isDarwin [
      "darwin=${toString darwinPath}"
      "darwin-config=${toString darwinConfigPath}"
    ];

    maxJobs = 10;
    distributedBuilds = false;

    binaryCaches = [
      "https://cache.nixos.org"
      "https://cachix.cachix.org"
      "https://all-hies.cachix.org"
    ];
    binaryCachePublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "all-hies.cachix.org-1:JjrzAOEUsD9ZMt8fdFbzo3jNAyEWlPAwdVuHw4RD43k="
    ];
  };

  programs.fish.enable = true;

  programs.bash.enableCompletion = true;
}
