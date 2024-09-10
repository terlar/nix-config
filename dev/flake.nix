{
  description = "Dependencies for development purposes";

  inputs = {
    dev-flake = {
      url = "github:terlar/dev-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        call-flake.url = "github:divnix/call-flake/a9bc85f5bd939734655327a824b4e7ceb4ccaba9";
      };
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = _: { };
}
