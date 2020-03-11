{ lib, pkgs, ... }:

let
  nixosUnstable = builtins.fetchTarball https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz;
in {
  imports = [
    ./caches.nix
    ./console.nix
    ./gnupg.nix
    ./yubikey.nix
  ];

  nix = {
    nixPath = [
      "nixpkgs=${toString <nixpkgs>}"
      "nixpkgs-overlays=${toString <nixpkgs-overlays>}"
      "dotfiles=${toString <dotfiles>}"
      "emacs-config=${toString <emacs-config>}"
      "home-manager=${toString <home-manager>}"
      "private=${toString <private>}"
      "nixos-config=${toString <nixos-config>}"
      "nixos-hardware=${toString <nixos-hardware>}"
    ];
  };

  nixpkgs = {
    config = import ../nixpkgs.nix;
    overlays = map
      (n: import (<nixpkgs-overlays> + ("/" + n)))
      (builtins.filter
        (n: builtins.match
          ".*\\.nix" n != null || builtins.pathExists (<nixpkgs-overlays> + ("/" + n + "/default.nix")))
        (lib.attrNames (builtins.readDir <nixpkgs-overlays>)));
  };

  programs.command-not-found.dbPath = "${nixosUnstable}/programs.sqlite";

  # Enable super user handling.
  security.sudo.enable = true;

  services = {
    # Time management.
    ntp.enable = true;

    # Auto-mount disks.
    udisks2.enable = true;
  };

  environment.systemPackages = import ./packages.nix { inherit pkgs; };
}
