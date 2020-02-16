{ config, pkgs, lib, ... }:

let
  emacsPackages = import ./packages.nix pkgs;
in {
  home.sessionVariables = {
    EDITOR = "emacseditor";
  };

  services.emacs.enable = true;
  programs = {
    emacs = {
      enable = true;
      package = pkgs.emacsGit;
      extraPackages = emacsPackages;
      overrides = pkgs.emacsPackagesOverrides;
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

    dataFile."applications/emacsclient.desktop".text = ''
      [Desktop Entry]
      Name=Emacsclient
      GenericName=Text Editor
      Comment=Edit text
      MimeType=text/english;text/plain;text/x-makefile;text/x-c++hdr;text/x-c++src;text/x-chdr;text/x-csrc;text/x-java;text/x-moc;text/x-pascal;text/x-tcl;text/x-tex;application/x-shellscript;text/x-c;text/x-c++;application/pdf;
      Exec=${pkgs.scripts.emacseditor}/bin/emacseditor %F
      Icon=emacs
      Type=Application
      Terminal=false
      Categories=Development;TextEditor;
      StartupWMClass=Emacs
      Keywords=Text;Editor;
    '';

    dataFile."applications/emacsmail.desktop".text = ''
      [Desktop Entry]
      Name=Emacsmail
      GenericName=Mail/News Client
      Comment=Mail/News Client
      Encoding=UTF-8
      MimeType=x-scheme-handler/mailto;
      Exec=${pkgs.scripts.emacsmail}/bin/emacsmail %u
      Icon=emacs
      Type=Application
      Terminal=false
      StartupWMClass=Emacs
    '';
  };
}
