{ pkgs, ... }:

let
  home_directory = builtins.getEnv "HOME";
  nix_directory = "${home_directory}/src/github.com/terlar/nix-config";
  ca-bundle_crt = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
  emacsPackages = import ./emacs.nix pkgs;
  emacsFull = pkgs.emacsPackagesNg.emacsWithPackages emacsPackages;
in rec {
  nixpkgs = {
    config = {
      allowUnfree = true;
    };

    overlays =
      let path = ../overlays; in with builtins;
      map (n: import (path + ("/" + n)))
      (filter (n: match ".*\\.nix" n != null ||
        pathExists (path + ("/" + n + "/default.nix")))
        (attrNames (readDir path)));
  };

  home = {
    packages = with pkgs; [
      emacsFull
    ];
  };

  programs = {
    home-manager = {
      enable = true;
      path = "${nix_directory}/home-manager";
    };

    direnv = {
      enable = true;
    };

    fish = {
      enable = true;
    };
  };

  xdg = {
    enable = true;

    configHome = "${home_directory}/.config";
    dataHome   = "${home_directory}/.local/share";
    cacheHome  = "${home_directory}/.cache";
  };

  services.emacs = {
    enable = true;
    package = emacsFull;
  }
}
