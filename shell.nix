{ nixpkgsPath ? ./external/nixpkgs
, overlaysPath ? ./overlays
, nixosConfigPath ? ./configuration.nix
, dotfilesPath ? ./external/dotfiles
, emacsConfigPath ? ./external/emacs.d
, homeManagerPath ? ./external/home-manager
, homeManagerConfigPath ? ./config/home.nix
, privateDataPath ? ./private/data.nix
}:

with (import nixpkgsPath {});

let
  nixPath = builtins.concatStringsSep ":" (lib.mapAttrsToList (name: value: name + "=" + (toString value)) {
    nixpkgs = nixpkgsPath;
    nixpkgs-overlays = overlaysPath;
    nixos-config = nixosConfigPath;
    home-manager = homeManagerPath;
    home-manager-config = homeManagerConfigPath;
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

  updateAllSources = writeShellScriptBin "update-all-sources" ''
    set -euo pipefail
    ${updateDotfileSources}/bin/update-dotfile-sources
    ${updateEmacsSources}/bin/update-emacs-sources
    ${updateNixSources}/bin/update-nix-sources
  '';

  updateDotfileSources = writeShellScriptBin "update-dotfile-sources" ''
    set -euo pipefail
    git submodule sync external/dotfiles external/emacs.d
    git submodule update --remote external/dotfiles
    git submodule update --remote external/emacs.d
  '';

  updateEmacsSources = writeShellScriptBin "update-emacs-sources" ''
    set -euo pipefail
    git submodule sync overlays/emacs
    git submodule update --remote overlays/emacs
  '';

  updateNixSources = writeShellScriptBin "update-nix-sources" ''
    set -euo pipefail
    git submodule sync external/home-manager external/nixpkgs
    git submodule update --remote external/home-manager
    git submodule update --remote external/nixpkgs
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
    git
    reloadEmacsConfig
    switchHome
    switchNixos
    updateAllSources
    updateDotfileSources
    updateEmacsSources
    updateNixSources
  ];

  shellHook = ''
    NIX_PATH=${nixPath}
    git submodule update --init
  '';
}
