{
  description = "Nix Config of Terje";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix.url = "github:NixOS/nix";
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

  outputs = inputs@{ self, nix, nixpkgs, home-manager, emacs-config, vsliveshare
    , menu, ... }:
    with builtins;
    with nixpkgs;

    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (self: super: { nixUnstable = nix.defaultPackage.${system}; })
          emacs-config.overlay
          menu.overlay
        ] ++ attrValues self.overlays;
        config.allowUnfree = true;
      };
    in {
      lib = rec {
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
            recursiveReadDir
            (filter (lib.hasSuffix ".nix"))
            (map (path: {
              name = lib.pipe path [
                toString
                (lib.removePrefix "${toString dir}/")
                (lib.removeSuffix "/default.nix")
                (lib.removeSuffix ".nix")
                kebabCaseToCamelCase
                (replaceStrings [ "/" ] [ "-" ])
              ];
              value = import path;
            }))
            listToAttrs
          ];

        nixosSystemFor =
          let specialArgs = { inherit (inputs) dotfiles hardware; };
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
                      specialArgs = specialArgs // { super = config; };
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

      packages.${system} = { inherit (pkgs) httpfs kmonad-bin rufo saw; };

      nixosConfigurations = let
        hosts = mapAttrs (host: _: self.lib.nixosSystemFor host { })
          (readDir ./nixos/hosts);

        installers = {
          yubikey-installer = lib.nixosSystem {
            inherit system;

            modules = [
              "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-base.nix"
              ({ pkgs, ... }: {
                services.pcscd.enable = true;
                services.udev.packages = [ pkgs.yubikey-personalization ];
                environment.systemPackages = with pkgs; [
                  gnupg
                  pinentry-curses
                  paperkey
                  wget
                ];

                programs = {
                  ssh.startAgent = false;
                  gnupg.agent = {
                    enable = true;
                    enableSSHSupport = true;
                  };
                };
              })
            ];
          };
        };
      in hosts // installers;

      nixosModules = self.lib.importDirToAttrs ./nixos/modules;
      homeManagerModules = self.lib.importDirToAttrs ./home-manager/modules;

      devShell.${system} =
        let scripts = import ./lib/scripts.nix { inherit pkgs; };
        in with pkgs;
        with scripts;
        mkShell {
          nativeBuildInputs = [
            cachix
            git
            nixUnstable
            nixfmt
            nixos-rebuild

            backup
            installQutebrowserDicts
            switchHome
            switchNixos
            useCaches
          ];

          shellHook = ''
            export NIX_USER_CONF_FILES=${toString ./.}/nix.conf
          '';
        };
    };
}
