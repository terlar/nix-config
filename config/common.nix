{ config, pkgs, lib, options, ... }:

let
  nixConf = builtins.getEnv "NIX_CONF";
in {
  time.timeZone = "Europe/Stockholm";

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = false;
      allowUnsupportedSystem = true;
    };

    overlays =
      let path = ../overlays; in with builtins;
      map (n: import (path + ("/" + n)))
      (filter (n: match ".*\\.nix" n != null ||
        pathExists (path + ("/" + n + "/default.nix")))
        (attrNames (readDir path)));
  };

  environment = {
    systemPackages = import ./packages.nix { inherit pkgs; };

    shells = [ pkgs.fish ];

    variables = {
      HOME_MANAGER_CONFIG = "${nixConf}/config/home.nix";

      MANPATH = [
        "${config.system.path}/share/man"
        "${config.system.path}/man"
        "/usr/local/share/man"
        "/usr/X11/man"
      ];

      LC_CTYPE    = "en_US.UTF-8";
      LESSCHARSET = "utf-8";
      PAGER       = "less";
      SHELL       = "${pkgs.fish}/bin/fish";
    };
  };

  nix = {
    package = pkgs.nixStable;
    nixPath =
      [ "nixpkgs=${nixConf}/nixpkgs"
        "home-manager=${nixConf}/home-manager"
      ] ++ lib.optionals pkgs.stdenv.isLinux [
        "nixos-config=${nixConf}/configuration.nix"
      ] ++ lib.optionals pkgs.stdenv.isDarwin [
        "darwin=${nixConf}/darwin"
        "darwin-config=${nixConf}/config/darwin.nix"
      ];

    maxJobs = 10;
    distributedBuilds = false;

    binaryCaches = options.nix.binaryCaches.default ++ [
      "https://cachix.cachix.org"
      "https://hie-nix.cachix.org"
    ];
    binaryCachePublicKeys = [
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "hie-nix.cachix.org-1:EjBSHzF6VmDnzqlldGXbi0RM3HdjfTU3yDRi9Pd0jTY="
    ];
  };

  programs.fish.enable = true;

  programs.bash.enableCompletion = true;
}
