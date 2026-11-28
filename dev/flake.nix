{
  description = "Dependencies for development purposes";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable-small/nixexprs.tar.zst";

    dev-flake = {
      url = "github:terlar/dev-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    first-ci-kit = {
      url = "github:terlar/first-ci-kit";
      inputs.flake-parts.follows = "dev-flake/flake-parts";
    };

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = _: { };
}
