{
  description = "Nix Config of Terje";

  nixConfig = {
    extra-substituters = "https://terlar.cachix.org";
    extra-trusted-public-keys = "terlar.cachix.org-1:M8CXTOaJib7CP/jEfpNJAyrgW4qECnOUI02q7cnmh8U=";
  };

  inputs = {
    flake-parts.url = "flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

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

    # Packages
    kmonad.url = "github:kmonad/kmonad?dir=nix";
    kmonad.inputs.nixpkgs.follows = "nixpkgs";
    nixgl.url = "github:guibou/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";

    # Sources
    dotfiles.url = "github:terlar/dotfiles";
    dotfiles.flake = false;
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];
      imports = [./flake-parts];
      perSystem = {pkgs, ...}: {
        formatter = pkgs.alejandra;
      };
    };
}
