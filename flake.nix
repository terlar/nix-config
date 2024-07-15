{
  description = "Nix Config of Terje";

  nixConfig = {
    extra-substituters = "https://terlar.cachix.org https://cuda-maintainers.cachix.org";
    extra-trusted-public-keys = "terlar.cachix.org-1:M8CXTOaJib7CP/jEfpNJAyrgW4qECnOUI02q7cnmh8U= cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E=";
  };

  inputs = {
    flake-parts.url = "flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    home-manager = {
      url = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-config = {
      url = "github:terlar/emacs-config";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Modules
    nixos-hardware.url = "nixos-hardware";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      flake-parts,
      nixpkgs,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      imports = [
        ./modules/flake/home-manager.nix
        ./configurations/home/terje
        ./configurations/nixos/kong
        ./configurations/nixos/installer-yubikey
      ];

      flake = {
        lib = import ./lib.nix { inherit (nixpkgs) lib; };

        homeModules = nixpkgs.lib.mkMerge [
          (self.lib.modulesFromDir ./modules/home)
          {
            user-terje = {
              imports = [
                self.homeModules.default
                inputs.emacs-config.homeManagerModules.emacsConfig
              ];
            };

            user-terje-linux = {
              imports = [ self.homeModules.user-terje ];

              targets.genericLinux.enable = true;

              nixpkgs.config.allowUnfreePredicate = nixpkgs.lib.const true;
              nixpkgs.overlays = builtins.attrValues self.overlays;
            };
          }
        ];

        nixosModules = self.lib.modulesFromDir ./modules/nixos;

        overlays = {
          default = import ./packages;
          fromInputs = nixpkgs.lib.composeManyExtensions [ inputs.emacs-config.overlays.default ];
        };
      };

      perSystem =
        { pkgs, ... }:
        {
          packages = {
            drduh-gpg-conf = pkgs.callPackage ./packages/drduh-gpg-conf { };
            drduh-yubikey-guide = pkgs.callPackage ./packages/drduh-yubikey-guide { };
          };
        };
    };
}
