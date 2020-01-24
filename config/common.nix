{ config, pkgs, lib, ... }:

let
  homeManagerConfigPath = ./home.nix;
in {
  time.timeZone = "Europe/Stockholm";

  nixpkgs.config = import ./nixpkgs.nix;
  nixpkgs.overlays = map
    (n: import (<nixpkgs-overlays> + ("/" + n)))
    (builtins.filter
      (n: builtins.match
        ".*\\.nix" n != null || builtins.pathExists (<nixpkgs-overlays> + ("/" + n + "/default.nix")))
      (lib.attrNames (builtins.readDir <nixpkgs-overlays>)));

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
      "nixpkgs=${toString <nixpkgs>}"
      "nixpkgs-overlays=${toString <nixpkgs-overlays>}"
      "home-manager=${toString <home-manager>}"
      "dotfiles=${toString <dotfiles>}"
      "emacs-config=${toString <emacs-config>}"
      "private-data=${toString <private-data>}"
    ] ++ lib.optionals pkgs.stdenv.isLinux [
      "nixos-config=${toString <nixos-config>}"
    ] ++ lib.optionals pkgs.stdenv.isDarwin [
      "darwin=${toString <darwin>}"
      "darwin-config=${toString <darwin-config>}"
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
