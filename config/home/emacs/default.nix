{ config, pkgs, lib, ... }:

let
  emacsPackages = import ./packages.nix pkgs;
in {
  home.sessionVariables.EDITOR = "emacseditor";

  services.emacs.enable = true;
  programs = {
    emacs = {
      enable = true;
      package = pkgs.emacsGit;
      extraPackages = emacsPackages;
      overrides = pkgs.emacsPackageOverrides;
    };

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

  xdg = {
    configFile."emacs/init.el".source = pkgs.runCommand "init.el" {} ''
      cp ${<emacs-config/init.org>} init.org
      ${pkgs.emacs}/bin/emacs -batch -q -no-site-file ./init.org -f org-babel-tangle
      mv init.el $out
    '';
    configFile."emacs/early-init.el".source = <emacs-config/early-init.el> ;
    configFile."emacs/lisp".source = <emacs-config/lisp> ;
    configFile."emacs/snippets".source = <emacs-config/snippets> ;
    configFile."emacs/templates".source = <emacs-config/templates> ;
  };
}
