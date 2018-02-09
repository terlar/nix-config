{ config, pkgs, ... }:

{
  nixpkgs.config.packageOverrides = super: {
    emacs = pkgs.stdenv.lib.overrideDerivation (super.emacs.override { srcRepo = true; }) (oldAttrs: rec {
      version = "27.0.50";
      versionModifier = "-git";
      name = "emacs-${version}${versionModifier}";

	    withGtk2 = false;
      withGtk3 = true;
      withXwidgets = true;
      imagemagick = pkgs.imagemagickBig;

      src = pkgs.fetchgit {
        url = "git://git.sv.gnu.org/emacs.git";
        rev = "1cdd0e8cd801aa1d6f04ab4d8e6097a46af8c951";
        sha256 = "0xgf63l4rlrabaxy6c2qxi76p3mg460c49b23g1rswigw2sc7c9f";
      };
      patches = [];
    });
  };

  environment.systemPackages = with pkgs; [
    aspell
    aspellDicts.en
    aspellDicts.sv
    emacs
  ];

  services.emacs.enable = true;
}
