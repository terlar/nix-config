{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, openssl
}:
rustPlatform.buildRustPackage
  rec {
    pname = "project-init";
    version = "3.1.19";
    src =
      fetchFromGitHub
        {
          owner = "vmchale";
          repo = pname;
          rev = version;
          sha256 = "sha256-NPcZSXa/uG0SrCrYIDb6CACrEep7cgfKzwEKsEoAj8E=";
        };
    cargoSha256 = "sha256-ctqLKC4UgBfpFzuZRJifJLYzeEY4+KhgGV4xtA+RLnw=";
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ openssl ];
    # requires unstable rust features
    RUSTC_BOOTSTRAP = 1;
  }
