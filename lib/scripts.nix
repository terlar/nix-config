{ pkgs }:

with pkgs;

{
  switchNixos = writeShellScriptBin "switch-nixos" ''
    sudo PATH=${lib.makeBinPath [ gitMinimal nixUnstable nixos-rebuild ]} nixos-rebuild switch --flake . $@
  '';

  switchHome = writeShellScriptBin "switch-home" ''
    ${home-manager}/bin/home-manager switch --flake . "$@"
  '';

  installQutebrowserDicts = writeShellScriptBin "install-qb-dicts" ''
    set -euo pipefail
    ${qutebrowser}/share/qutebrowser/scripts/dictcli.py install $@
  '';

  useCaches = writeShellScriptBin "use-caches" ''
    cachix use -O . nix-community
    cachix use -O . terlar
  '';

  backup = writeShellScriptBin "backup" ''
    set -euo pipefail
    TIMESTAMP="$(date +%Y%m%d%H%M%S)"
    BACKUP_DIR="backup/$TIMESTAMP"
    mkdir -p "$BACKUP_DIR/fish" "$BACKUP_DIR/gnupg"
    cp "$HOME"/.local/share/fish/fish_history* "$BACKUP_DIR/fish"
    cp "$HOME"/.gnupg/sshcontrol "$BACKUP_DIR/gnupg"
  '';
}
