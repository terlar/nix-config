{ pkgs ? import <nixpkgs> {} }:

let
  reloadEmacsConfig = pkgs.writeShellScriptBin "reload-emacs-config" ''
    set -euxo pipefail

    home-manager -b bak switch
    echo "Home generation: $(home-manager generations | head -1)"

    systemctl --user restart emacs.service

    while ! emacsclient -a false -e t 2>/dev/null
    do sleep 1; done
    emacsclient -nc
  '';
in pkgs.mkShell {
  buildInputs = [
    reloadEmacsConfig
  ];
}
