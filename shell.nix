let
  hostname = builtins.replaceStrings ["\n"] [""] (builtins.readFile /etc/hostname);
  hostNixosConfig = ./hosts + "/${hostname}/configuration.nix";
  defaultNixosConfig =
    if (builtins.pathExists hostNixosConfig)
    then hostNixosConfig
    else /etc/nixos/configuration.nix;
in
{ nixpkgs ? ./external/nixpkgs
, overlays ? ./overlays
, nixos-config ? defaultNixosConfig
, nixos-hardware ? ./external/nixos-hardware
, home-manager ? ./external/home-manager
, dotfiles ? ./external/dotfiles
, emacs-config ? ./external/emacs.d
, private ? ../nix-config-private
}:

with (import nixpkgs {});

let
  nixPath = builtins.concatStringsSep ":" (lib.mapAttrsToList (name: value: name + "=" + (toString value)) {
    nixpkgs-overlays = overlays;
    inherit nixpkgs
      dotfiles emacs-config
      home-manager
      nixos-config nixos-hardware
      private;
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
    git submodule sync external/home-manager external/nixos-hardware external/nixos-vsliveshare external/nixpkgs
    git submodule update --remote external/home-manager
    git submodule update --remote external/nixos-hardware
    git submodule update --remote external/nixos-vsliveshare
    git submodule update --remote external/nixpkgs
  '';

  reloadEmacsConfig = writeShellScriptBin "reload-emacs-config" ''
    set -euo pipefail
    systemctl --user restart emacs.service
    while ! emacsclient -a false -e t 2>/dev/null
    do sleep 1; done
    emacsclient -nc
  '';

  installQutebrowserDicts = writeShellScriptBin "install-qb-dicts" ''
    set -euo pipefail
    ${qutebrowser}/share/qutebrowser/scripts/dictcli.py install $@
  '';

  backup = writeShellScriptBin "backup" ''
    set -euo pipefail
    TIMESTAMP="$(date +%Y%m%d%H%M%S)"
    BACKUP_DIR="backup/$TIMESTAMP"
    mkdir -p "$BACKUP_DIR/fish" "$BACKUP_DIR/gnupg"
    cp "$HOME"/.local/share/fish/fish_history* "$BACKUP_DIR/fish"
    cp "$HOME"/.gnupg/sshcontrol "$BACKUP_DIR/gnupg"
  '';
in mkShell {
  buildInputs = [
    backup
    git
    installQutebrowserDicts
    reloadEmacsConfig
    switchHome
    switchNixos
    updateAllSources
    updateDotfileSources
    updateEmacsSources
    updateNixSources
  ];

  shellHook = ''
    NIXPKGS_CONFIG=${./config/nixpkgs.nix}
    NIX_PATH=${nixPath}
    git submodule update --init
  '';
}
