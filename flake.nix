{
  description = "Nix Config of Terje";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "/nixpkgs";
    };
    emacs-config = {
      url = "github:terlar/emacs-config";
      inputs = {
        nixpkgs.follows = "/nixpkgs";
        home-manager.follows = "/home-manager";
      };
    };

    # Modules
    hardware = {
      url = "github:NixOS/nixos-hardware";
      flake = false;
    };
    vsliveshare = {
      url = "github:msteen/nixos-vsliveshare";
      flake = false;
    };

    # Packages
    manix = {
      url = "github:mlvzk/manix";
      inputs.nixpkgs.follows = "/nixpkgs";
    };
    menu = {
      url = "github:terlar/menu";
      inputs.nixpkgs.follows = "/nixpkgs";
    };
    nix-tree = {
      url = "github:utdemir/nix-tree";
      inputs.nixpkgs.follows = "/nixpkgs";
    };

    # Sources
    dotfiles = {
      url = "github:terlar/dotfiles";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, emacs-config, vsliveshare
    , manix, menu, nix-tree, ... }:
    with builtins;
    with nixpkgs;

    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          emacs-config.overlay
          menu.overlay
          nix-tree.overlay
          (self: super: { manix = manix.defaultPackage.${system}; })
        ] ++ attrValues self.overlays;
        config.allowUnfree = true;
      };
    in {
      lib = rec {
        kebabCaseToCamelCase =
          replaceStrings (map (s: "-${s}") lib.lowerChars) lib.upperChars;
        importDirToAttrs = dir:
          listToAttrs (map (name: {
            name = kebabCaseToCamelCase (lib.removeSuffix ".nix" name);
            value = import (dir + "/${name}");
          }) (attrNames (readDir dir)));

        nixosSystemFor = let
          specialArgs = {
            inherit (inputs) dotfiles hardware;
            # profiles = self.lib.importDirToAttrs ./nixos/profiles;
          };
        in host:
        { extraModules ? [ ], ... }@args:
        lib.nixosSystem {
          inherit system specialArgs;

          modules = let
            nixosConfig = ./nixos/hosts + "/${host}";
            nixos = import nixosConfig;

            common = {
              system.stateVersion = "19.09";
              system.configurationRevision = lib.mkIf (self ? rev) self.rev;
              nixpkgs = { inherit pkgs; };
              nix.nixPath = [
                "nixpkgs=${nixpkgs}"
                "nixos-config=${nixosConfig}"
                "nixos-hardware=${inputs.hardware}"
                "dotfiles=${inputs.dotfiles}"
              ];
              nix.registry.nixpkgs.flake = nixpkgs;
            };

            home = { config, ... }: {
              options.home-manager.users = lib.mkOption {
                type = with lib.types;
                  attrsOf (submoduleWith {
                    specialArgs = specialArgs // {
                      super = config;
                      # profiles = self.lib.importDirToAttrs ./home-manager/profiles;
                    };
                    modules = [
                      emacs-config.homeManagerModules.emacsConfig
                      "${vsliveshare}/modules/vsliveshare/home.nix"
                    ] ++ (attrValues self.homeManagerModules);
                  });
              };

              config = {
                home-manager = {
                  useGlobalPkgs = true;
                  backupFileExtension = "bak";
                };
              };
            };
          in [
            nixpkgs.nixosModules.notDetected
            home-manager.nixosModules.home-manager
            home
            common
            nixos
          ] ++ (attrValues self.nixosModules) ++ extraModules;
        };
      };

      overlay = self.overlays.pkgs;
      overlays = {
        pkgs = import ./pkgs;
      } // self.lib.importDirToAttrs ./overlays;

      packages.${system} = {
        inherit (pkgs)
          google-chrome-beta-with-pipewire google-chrome-dev-with-pipewire
          httpfs kmonad-bin rufo saw;
      };

      nixosConfigurations = mapAttrs (host: _: self.lib.nixosSystemFor host { })
        (readDir ./nixos/hosts);

      nixosModules = self.lib.importDirToAttrs ./nixos/modules;
      homeManagerModules = self.lib.importDirToAttrs ./home-manager/modules;

      devShell.${system} =
        let scripts = import ./lib/scripts.nix { inherit pkgs; };
        in with pkgs;
        with scripts;
        mkShell {
          nativeBuildInputs = [
            git
            nixfmt

            backup
            installQutebrowserDicts
            switchHome
            switchNixos
          ];
        };
    };
}
