{ nixpkgsPath ? ./external/nixpkgs
, overlaysPath ? ./overlays
, nixosConfigPath ? ./configuration.nix
, dotfilesPath ? ./external/dotfiles
, emacsConfigPath ? ./external/emacs.d
, homeManagerPath ? ./external/home-manager
, privateDataPath ? ./private/data.nix
}:

with (import nixpkgsPath {});

let
  nixPath = builtins.concatStringsSep ":" (lib.mapAttrsToList (name: value: name + "=" + (toString value)) {
    nixpkgs = nixpkgsPath;
    nixpkgs-overlays = overlaysPath;
    nixos-config = nixosConfigPath;
    home-manager = homeManagerPath;
    dotfiles = dotfilesPath;
    emacs-config = emacsConfigPath;
    private-data = privateDataPath;
  });

  switchNixos = writeShellScriptBin "switch-nixos" ''
    set -euo pipefail
    sudo -E nixos-rebuild switch $@
  '';

  switchHome = writeShellScriptBin "switch-home" ''
    set -euo pipefail
    home-manager -b bak switch $@
    echo "Home generation: $(home-manager generations | head -1)"
  '';

  reloadEmacsConfig = writeShellScriptBin "reload-emacs-config" ''
    set -euo pipefail
    ${switchHome}/bin/switch-home
    systemctl --user restart emacs.service
    while ! emacsclient -a false -e t 2>/dev/null
    do sleep 1; done
    emacsclient -nc
  '';
in mkShell {
  buildInputs = [
    switchHome
    switchNixos
    reloadEmacsConfig
  ];

  shellHook = ''
    NIX_PATH=${nixPath}
  '';
}