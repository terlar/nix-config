{ config, pkgs, ... }:

let
  homeDirectory = builtins.getEnv "HOME";
  nixDirectory = "${homeDirectory}/src/github.com/terlar/nix-config";
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
      HOME_MANAGER_CONFIG = "${nixDirectory}/config/home.nix";

      MANPATH = [
        "${homeDirectory}/.nix-profile/share/man"
        "${homeDirectory}/.nix-profile/man"
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
      [ "home-manager=${nixDirectory}/home-manager"
        "darwin=${nixDirectory}/darwin"
        "darwin-config=${nixDirectory}/config/darwin.nix"
        "nixpkgs=${nixDirectory}/nixpkgs"
      ];

    maxJobs = 10;
    distributedBuilds = false;
  };

  programs.fish.enable = true;

  programs.bash.enableCompletion = true;
}
