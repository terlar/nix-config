{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./yubikey-gpg.nix
    ./laptop.nix
    ./gui.nix
    ./dev.nix
  ];

  hardware.bumblebee = {
    enable = true;
    pmMethod = "none";
    connectDisplay = true;
  };

  boot.blacklistedKernelModules = [ "nouveau" "bbswitch" ];

  networking.hostName = "kong";
  time.timeZone = "Europe/Stockholm";

  nixpkgs.config.allowUnfree = true;

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

  system.autoUpgrade.enable = true;
  system.stateVersion = "17.09";
}
