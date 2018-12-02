{ config, pkgs, ... }:

let
  home_directory = builtins.getEnv "HOME";
  nix_directory = "${home_directory}/src/github.com/terlar/nix-config";
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
      HOME_MANAGER_CONFIG = "${nix_directory}/config/home.nix";

      MANPATH = [
        "${home_directory}/.nix-profile/share/man"
        "${home_directory}/.nix-profile/man"
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
      [ "home-manager=${nix_directory}/home-manager"
        "darwin=${nix_directory}/darwin"
        "darwin-config=${nix_directory}/config/darwin.nix"
        "nixpkgs=${nix_directory}/nixpkgs"
      ];

    maxJobs = 10;
    distributedBuilds = false;
  };

  programs.bash.enable = true;
  programs.fish.enable = true;
}
