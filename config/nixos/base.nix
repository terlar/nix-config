{ config, lib, pkgs, ... }:

let
  nixosUnstable = builtins.fetchTarball https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz;
in {
  nix = {
    nixPath = [
      "nixpkgs=${toString <nixpkgs>}"
      "nixpkgs-overlays=${toString <nixpkgs-overlays>}"
      "dotfiles=${toString <dotfiles>}"
      "emacs-config=${toString <emacs-config>}"
      "home-manager=${toString <home-manager>}"
      "private=${toString <private>}"
    ] ++ lib.optionals (builtins.pathExists <nixos-config>) [
      "nixos-config=${toString <nixos-config>}"
      "nixos-hardware=${toString <nixos-hardware>}"
    ];

    binaryCaches = [
      "https://cache.nixos.org"
      "https://all-hies.cachix.org"
      "https://cachix.cachix.org"
      "https://emacs-ci.cachix.org"
      "https://iohk.cachix.org"
    ];
    binaryCachePublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "all-hies.cachix.org-1:JjrzAOEUsD9ZMt8fdFbzo3jNAyEWlPAwdVuHw4RD43k="
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "emacs-ci.cachix.org-1:B5FVOrxhXXrOL0S+tQ7USrhjMT5iOPH+QN9q0NItom4="
      "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo="
    ];

    gc.automatic = true;
    gc.dates = "12:12";
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

  services = {
    # Time management.
    ntp.enable = true;

    # Virtual terminal.
    kmscon = {
      enable = true;
      hwRender = true;
      extraConfig = ''
        palette=solarized-white
        font-name=Iosevka Slab
        font-size=16
      '';
    };

    # Auto-mount disks.
    udisks2.enable = true;
  };

  programs = {
    command-not-found.dbPath = "${nixosUnstable}/programs.sqlite";

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  environment = {
    systemPackages = import ../packages.nix { inherit pkgs; };

    shells = [ pkgs.fish ];

    variables = {
      LC_CTYPE    = "en_US.UTF-8";
      LESSCHARSET = "utf-8";
      PAGER       = "less";
      SHELL       = "${pkgs.fish}/bin/fish";
    };
  };

  programs.bash.enableCompletion = true;
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
}
