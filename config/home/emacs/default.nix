{ config, pkgs, lib, ... }:

let
  emacs = {
    enable = true;
    package = pkgs.emacsGit;
    extraPackages = import ./packages.nix pkgs;
    overrides = pkgs.emacsPackageOverrides;
  };

  config = pkgs.callPackage ./config.nix {
    src = <emacs-config> ;
    emacs = emacs.package;
    inherit (emacs) extraPackages overrides;
  };

  setConfigFiles = with builtins; path:
    foldl'
      (acc: file: acc // { "emacs/${file}".source = "${path}/${file}"; })
      { }
      (attrNames (readDir path));
in {
  home.sessionVariables.EDITOR = "emacseditor";

  services.emacs.enable = true;
  programs = {
    inherit emacs;

    git = {
      extraConfig = {
        diff.tool = "ediff";

        "difftool \"ediff\"".cmd = ''
          emacsclient --eval '(ediff-files "'$LOCAL'" "'$REMOTE'")'
        '';

        "mergetool \"ediff\"".cmd = ''
          emacsclient --eval '(ediff-merge-files-with-ancestor "'$LOCAL'" "'$REMOTE'" "'$BASE'" nil "'$MERGED'")'
        '';
      };
    };
  };

  xdg.configFile = {
    "emacs/lisp".source = <emacs-config/lisp> ;
    "emacs/snippets".source = <emacs-config/snippets> ;
    "emacs/templates".source = <emacs-config/templates> ;
  } // setConfigFiles "${config}/share/emacs/site-lisp";
}
