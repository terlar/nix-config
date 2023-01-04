{
  description = "Nix Config of Terje";

  nixConfig = {
    extra-substituters = "https://terlar.cachix.org";
    extra-trusted-public-keys = "terlar.cachix.org-1:M8CXTOaJib7CP/jEfpNJAyrgW4qECnOUI02q7cnmh8U=";
  };

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;

    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";

    emacs-config.url = "github:terlar/emacs-config";
    emacs-config.inputs.flake-compat.follows = "flake-compat";
    emacs-config.inputs.home-manager.follows = "home-manager";
    emacs-config.inputs.nixpkgs.follows = "nixpkgs";

    # Modules
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # Packages
    kmonad.url = "github:kmonad/kmonad?dir=nix";
    kmonad.inputs.nixpkgs.follows = "nixpkgs";
    nixgl.url = "github:guibou/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";
    devenv.url = "github:cachix/devenv/v0.5";
    devenv.inputs.nixpkgs.follows = "nixpkgs";

    # Sources
    dotfiles.url = "github:terlar/dotfiles";
    dotfiles.flake = false;
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];
      imports = [./flake-parts];
    };
}
