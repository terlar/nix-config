{
  description = "Nix Config of Terje";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix.url = "github:NixOS/nix/b19aec7eeb8353be6c59b2967a511a5072612d99";
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
    nixGL = {
      url = "github:guibou/nixGL";
      flake = false;
    };
    vsliveshare = {
      url = "github:msteen/nixos-vsliveshare";
      flake = false;
    };

    # Packages
    menu = {
      url = "github:terlar/menu";
      inputs.nixpkgs.follows = "/nixpkgs";
    };

    # Sources
    dotfiles = {
      url = "github:terlar/dotfiles";
      flake = false;
    };
  };

  outputs = inputs@{ self, nix, nixpkgs, home-manager, emacs-config, ... }:
    with builtins;
    let
      inherit (nixpkgs) lib;

      homeManagerExtraModules = [
        emacs-config.homeManagerModules.emacsConfig
        "${inputs.vsliveshare}/modules/vsliveshare/home.nix"
      ] ++ (attrValues self.homeManagerModules);
    in {
      lib = {
        kebabCaseToCamelCase =
          replaceStrings (map (s: "-${s}") lib.lowerChars) lib.upperChars;

        recursiveReadDir = let
          recurse = rootPath:
            let
              contents = readDir rootPath;
              list = lib.mapAttrsToList (name: type:
                let path = rootPath + "/${name}";
                in if type == "directory" then recurse path else [ path ])
                contents;
            in lib.flatten list;
        in recurse;

        importDirToAttrs = dir:
          lib.pipe dir [
            self.lib.recursiveReadDir
            (filter (lib.hasSuffix ".nix"))
            (map (path: {
              name = lib.pipe path [
                toString
                (lib.removePrefix "${toString dir}/")
                (lib.removeSuffix "/default.nix")
                (lib.removeSuffix ".nix")
                self.lib.kebabCaseToCamelCase
                (replaceStrings [ "/" ] [ "-" ])
              ];
              value = import path;
            }))
            listToAttrs
          ];

        pkgsForSystem = { system, extraOverlays ? [ ] }:
          let
            nixOverlay = self: super: {
              nixUnstable = nix.defaultPackage.${system};
            };

            nixGLOverlay = self: super:
              let nixGL = import inputs.nixGL { pkgs = self; };
              in { inherit (nixGL) nixGLNvidia nixGLIntel nixGLDefault; };

            inputOverlays = [
              nixOverlay
              nixGLOverlay
              emacs-config.overlay
              inputs.menu.overlay
            ];
            selfOverlays = attrValues self.overlays;
          in import nixpkgs {
            inherit system;
            overlays = inputOverlays ++ selfOverlays ++ extraOverlays;
            config.allowUnfree = true;
          };

        forAllSystems = f:
          lib.genAttrs [ "x86_64-linux" ]
          (system: f (self.lib.pkgsForSystem { inherit system; }));

        nixosSystem = { system ? "x86_64-linux", configuration ? { }
          , extraModules ? [ ], extraOverlays ? [ ], specialArgs ? { }, ... }:
          let
            pkgs = self.lib.pkgsForSystem { inherit system extraOverlays; };

            baseNixosModule = {
              system.configurationRevision = lib.mkIf (self ? rev) self.rev;
              nixpkgs = { inherit pkgs; };
              nix.nixPath = [ "nixpkgs=${nixpkgs}" ];
              nix.registry.nixpkgs.flake = nixpkgs;
            };

            homeNixosModule = { config, ... }: {
              options.home-manager.users = lib.mkOption {
                type = with lib.types;
                  attrsOf (submoduleWith {
                    specialArgs = specialArgs // { super = config; };
                    modules = homeManagerExtraModules;
                  });
              };

              config.home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "bak";
              };
            };
          in lib.nixosSystem {
            inherit system specialArgs;

            modules = [ baseNixosModule homeNixosModule configuration ];

            extraModules = [
              nixpkgs.nixosModules.notDetected
              home-manager.nixosModules.home-manager
            ] ++ (attrValues self.nixosModules) ++ extraModules;
          };

        nixosSystemFor = args@{ host, extraConfiguration ? { }, ... }:
          self.lib.nixosSystem ({
            configuration = {
              imports = [ (./nixos/hosts + "/${host}") extraConfiguration ];
            };

            specialArgs = { inherit (inputs) dotfiles hardware; };
          } // args);

        nixosInstaller = args@{ extraModules ? [ ], ... }:
          self.lib.nixosSystem (args // {
            extraModules = [
              "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-base.nix"
            ] ++ extraModules;
          });

        homeManagerConfiguration = { username, configuration
          # Optional arguments
          , extraSpecialArgs ? { }, homeDirectory ? "/home/${username}"
          , system ? "x86_64-linux"
          , pkgs ? (self.lib.pkgsForSystem { inherit system; })
          , isGenericLinux ? pkgs.stdenv.hostPlatform.isLinux }:
          home-manager.lib.homeManagerConfiguration {
            inherit username homeDirectory system pkgs;

            extraSpecialArgs = {
              inherit (inputs) dotfiles hardware;
            } // extraSpecialArgs // {
              inherit pkgs;
            };

            configuration = {
              imports = homeManagerExtraModules ++ [ configuration ];
              targets.genericLinux.enable = isGenericLinux;
            };
          };
      };

      overlay = self.overlays.pkgs;
      overlays = {
        pkgs = import ./pkgs;
      } // self.lib.importDirToAttrs ./overlays;

      packages =
        self.lib.forAllSystems (pkgs: { inherit (pkgs) httpfs rufo saw; });

      nixosConfigurations = let
        hosts = mapAttrs (host: _: self.lib.nixosSystemFor { inherit host; })
          (readDir ./nixos/hosts);

        installers = lib.mapAttrs' (name: _: {
          name = "${name}-installer";
          value = self.lib.nixosInstaller {
            configuration = ./nixos/installer + "/${name}";
          };
        }) (readDir ./nixos/installer);
      in hosts // installers;

      homeManagerConfigurations = {
        terje = self.lib.homeManagerConfiguration {
          username = "terje";
          configuration.profiles.user.terje.graphical.enable = true;
        };
      };

      nixosModules = self.lib.importDirToAttrs ./nixos/modules;
      homeManagerModules = self.lib.importDirToAttrs ./home-manager/modules;

      devShell = self.lib.forAllSystems (pkgs:
        let scripts = import ./lib/scripts.nix { inherit pkgs; };
        in with pkgs;
        with scripts;

        mkShell {
          nativeBuildInputs = [
            cachix
            git
            nixUnstable
            nixfmt

            backup
            installQutebrowserDicts
            switchHome
            switchNixos
            useCaches
          ];

          shellHook = ''
            export NIX_USER_CONF_FILES=${toString ./.}/nix.conf
          '';
        });
    };
}
