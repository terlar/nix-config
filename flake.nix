{
  description = "Nix Config of Terje";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-config = {
      url = "github:terlar/emacs-config";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    # Modules
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixGL = {
      url = "github:guibou/nixGL?rev=8687d0ea4c08893b47f7c727e1ef8284bc54c142";
      flake = false;
    };
    vsliveshare = {
      url = "github:msteen/nixos-vsliveshare";
      flake = false;
    };

    # Packages
    kmonad = {
      url = "github:kmonad/kmonad?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    menu = {
      url = "github:terlar/menu";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Sources
    dotfiles = {
      url = "github:terlar/dotfiles";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nixos-hardware, emacs-config, ... }:
    with builtins;
    let
      inherit (nixpkgs) lib;

      homeManagerExtraModules = [
        emacs-config.homeManagerModules.emacsConfig
        "${inputs.vsliveshare}/modules/vsliveshare/home.nix"
      ] ++ (attrValues self.homeManagerModules);
    in
    {
      lib = {
        kebabCaseToCamelCase =
          replaceStrings (map (s: "-${s}") lib.lowerChars) lib.upperChars;

        importDirToAttrs = dir:
          lib.pipe dir [
            lib.filesystem.listFilesRecursive
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
            homeManagerOverlay = final: prev:
              { home-manager = home-manager.defaultPackage.${system}; };

            nixGLOverlay = final: prev:
              let
                nixGL = import inputs.nixGL { pkgs = final; };
                wrapWithNixGL = wrapper: package:
                  let
                    getBinFiles = pkg:
                      lib.pipe "${lib.getBin pkg}/bin" [
                        readDir
                        attrNames
                        (filter (n: match "^\\..*" n == null))
                      ];

                    wrapperBin = lib.pipe wrapper [
                      getBinFiles
                      (filter (n: n == (lib.getName wrapper)))
                      head
                      (x: "${wrapper}/bin/${x}")
                    ];

                    binFiles = getBinFiles package;
                    wrapBin = name:
                      final.writeShellScriptBin name ''
                        exec ${wrapperBin} ${package}/bin/${name} "$@"
                      '';
                  in
                  final.symlinkJoin {
                    name = "${package.name}-nixgl";
                    paths = (map wrapBin binFiles) ++ [ package ];
                  };

                wrappers =
                  let
                    replacePrefix =
                      replaceStrings [ "wrapWithNixGL" ] [ "nixGL" ];
                  in
                  lib.genAttrs [
                    "wrapWithNixGLNvidia"
                    "wrapWithNixGLIntel"
                    "wrapWithNixGLDefault"
                  ]
                    (name: wrapWithNixGL final.${replacePrefix name});
              in
              {
                inherit (nixGL) nixGLNvidia nixGLIntel nixGLDefault;
                inherit wrapWithNixGL;
              } // wrappers;

            inputOverlays = [
              nixGLOverlay
              homeManagerOverlay
              emacs-config.overlay
              inputs.kmonad.overlay
              inputs.menu.overlay
            ];
            selfOverlays = attrValues self.overlays;
          in
          import nixpkgs {
            inherit system;
            overlays = inputOverlays ++ selfOverlays ++ extraOverlays;
            config.allowUnfree = true;
          };

        forAllSystems = f:
          lib.genAttrs [ "x86_64-linux" ]
            (system: f (self.lib.pkgsForSystem { inherit system; }));

        nixosSystem =
          { system ? "x86_64-linux"
          , configuration ? { }
          , modules ? [ ]
          , extraModules ? [ ]
          , extraOverlays ? [ ]
          , specialArgs ? { }
          , ...
          }:
          let
            pkgs = self.lib.pkgsForSystem { inherit system extraOverlays; };

            baseNixosModule = {
              system.configurationRevision = lib.mkIf (self ? rev) self.rev;
              nixpkgs = { inherit pkgs; };
              nix.nixPath = [ "nixpkgs=${nixpkgs}" ];
              nix.registry.nixpkgs.flake = nixpkgs;
            };

            homeNixosModule = { config, ... }: {
              config.home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "bak";

                extraSpecialArgs = specialArgs;
                sharedModules = homeManagerExtraModules;
              };
            };
          in
          lib.nixosSystem {
            inherit system specialArgs;

            modules = [ baseNixosModule homeNixosModule configuration ] ++ modules;

            extraModules = [
              nixpkgs.nixosModules.notDetected
              home-manager.nixosModules.home-manager
            ] ++ (attrValues self.nixosModules) ++ extraModules;
          };

        nixosInstaller = args@{ extraModules ? [ ], ... }:
          self.lib.nixosSystem (args // {
            extraModules = [
              "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-base.nix"
            ] ++ extraModules;
          });

        homeManagerConfiguration =
          let
            homeDirectoryPrefix = pkgs:
              if pkgs.stdenv.hostPlatform.isDarwin then "/Users" else "/home";
          in
          { username
          , configuration
            # Optional arguments
          , system ? "x86_64-linux"
          , extraModules ? [ ]
          , extraSpecialArgs ? { }
          , pkgs ? (self.lib.pkgsForSystem { inherit system; })
          , nixPath ? "nixpkgs=${pkgs.path}"
          , homeDirectory ? "${homeDirectoryPrefix pkgs}/${username}"
          , isGenericLinux ? pkgs.stdenv.hostPlatform.isLinux
          }:
          home-manager.lib.homeManagerConfiguration {
            inherit username homeDirectory system pkgs;

            extraSpecialArgs = {
              inherit (inputs) dotfiles;
            } // extraSpecialArgs;

            extraModules = homeManagerExtraModules ++ extraModules;
            configuration = {
              imports = [ configuration ];
              targets.genericLinux.enable = isGenericLinux;

              home.sessionVariables.NIX_PATH = nixPath;
              systemd.user.sessionVariables.NIX_PATH = lib.mkForce nixPath;
            };
          };

        nixosHosts = {
          beetle = {
            configuration = ./nixos/hosts/beetle;
            modules = [
              nixos-hardware.nixosModules.common-cpu-intel
              nixos-hardware.nixosModules.common-pc-laptop
              nixos-hardware.nixosModules.common-pc-ssd
            ];
            specialArgs = { inherit (inputs) dotfiles; };
          };

          kong = {
            configuration = ./nixos/hosts/kong;
            modules = [
              nixos-hardware.nixosModules.common-cpu-intel
              nixos-hardware.nixosModules.common-pc-laptop
              nixos-hardware.nixosModules.common-pc-ssd
            ];
            specialArgs = { inherit (inputs) dotfiles; };
          };

          snail = {
            system = "aarch64-linux";

            configuration = { pkgs, ... }: {
              hardware.enableRedistributableFirmware = true;

              networking = {
                hostName = "snail";
                wireless.enable = true;
              };

              boot = {
                kernelParams = [
                  "console=ttyS1,115200n8"
                ];

                loader.raspberryPi = {
                  enable = true;
                  version = 3;
                  uboot.enable = true;
                  firmwareConfig = ''
                    start_x=1
                    gpu_mem=256
                  '';
                };
              };

              services.openssh.enable = true;

              services.unifi = {
                enable = true;
                unifiPackage = pkgs.unifi;
              };

              users.users.root.openssh.authorizedKeys.keys = [
                "your public key here"
              ];

              systemd.services.btattach = {
                before = [ "bluetooth.service" ];
                after = [ "dev-ttyAMA0.device" ];
                wantedBy = [ "multi-user.target" ];
                serviceConfig = {
                  ExecStart = "${pkgs.bluez}/bin/btattach -B /dev/ttyAMA0 -P bcm -S 3000000";
                };
              };

              environment.systemPackages = [
                pkgs.emacs
              ];
            };
          };
        };
      };

      overlay = self.overlays.pkgs;
      overlays = {
        pkgs = import ./pkgs;
      } // self.lib.importDirToAttrs ./overlays;

      packages =
        let homePackages = builtins.mapAttrs (_: lib.getAttr "activationPackage") self.homeConfigurations; in
        self.lib.forAllSystems
          (pkgs: {
            inherit (pkgs) rufo saw;
            inherit (pkgs.gnomeExtensions) paperwm;
          } // lib.pipe homePackages [
            (lib.filterAttrs (_: p: pkgs.system == p.system))
            (lib.mapAttrs' (username: p: lib.nameValuePair "${username}-home" p))
          ]);

      nixosConfigurations = {
        beetle = self.lib.nixosSystem self.lib.nixosHosts.beetle;
        kong = self.lib.nixosSystem self.lib.nixosHosts.kong;
        # snail = self.lib.nixosSystem self.lib.nixosHosts.snail;
        yubikey-installer = self.lib.nixosInstaller {
          configuration = ./nixos/installer/yubikey;
        };
      };

      homeConfigurations = {
        terje = self.lib.homeManagerConfiguration {
          username = "terje";
          configuration.profiles.user.terje.graphical.enable = true;
        };
      };

      nixosModules = self.lib.importDirToAttrs ./nixos/modules;
      homeManagerModules = self.lib.importDirToAttrs ./home-manager/modules;

      apps = self.lib.forAllSystems
        (pkgs:
          mapAttrs
            (bin: drv: {
              type = "app";
              program = "${drv}/bin/${bin}";
            })
            {
              use-caches = pkgs.writers.writeBashBin "use-caches" ''
                ${pkgs.cachix}/bin/cachix use -O . nix-community
                ${pkgs.cachix}/bin/cachix use -O . terlar
              '';

              home-switch = pkgs.writers.writeBashBin "home-switch" ''
                ${home-manager.defaultApp.${pkgs.system}.program} switch --flake . "$@"
              '';

              nixos-switch = pkgs.writers.writeBashBin "switch-nixos" ''
                sudo PATH=${lib.makeBinPath [ pkgs.gitMinimal pkgs.nixUnstable pkgs.nixos-rebuild ]}:$PATH nixos-rebuild switch --flake . $@
              '';

              install-qutebrowser-dicts = pkgs.writers.writeBashBin "install-qutebrowser-dicts" ''
                set -euo pipefail
                ${pkgs.qutebrowser}/share/qutebrowser/scripts/dictcli.py install $@
              '';

              backup = pkgs.writers.writeBashBin "backup" ''
                set -euo pipefail
                TIMESTAMP="$(date +%Y%m%d%H%M%S)"
                BACKUP_DIR="backup/$TIMESTAMP"
                mkdir -p "$BACKUP_DIR/fish" "$BACKUP_DIR/gnupg"
                cp "$HOME"/.local/share/fish/fish_history* "$BACKUP_DIR/fish"
                cp "$HOME"/.gnupg/sshcontrol "$BACKUP_DIR/gnupg"
              '';
            });

      devShell = self.lib.forAllSystems (pkgs:
        pkgs.mkShell {
          nativeBuildInputs = [
            pkgs.git
            pkgs.nix_2_4
            pkgs.nixpkgs-fmt
          ];

          shellHook = ''
            export NIX_USER_CONF_FILES=${toString ./.}/nix.conf
          '';
        });
    };
}
