final: prev:

{
  nix-direnv = prev.nix-direnv.overrideAttrs (old: {
    postPatch = ''
      substituteInPlace direnvrc \
        --replace "grep" "${final.gnugrep}/bin/grep" \
        --replace "nix-shell" "${final.nixUnstable}/bin/nix-shell" \
        --replace "nix-instantiate" "${final.nixUnstable}/bin/nix-instantiate"
    '';
  });
}
