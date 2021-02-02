{ pkgs }:

with pkgs;

{
  switchNixos = writeShellScriptBin "switch-nixos" ''
    set -euo pipefail
    sudo nixos-rebuild switch --flake . $@
  '';

  switchHome = writeShellScriptBin "switch-home" ''
    set -euo pipefail
    export PATH=${lib.makeBinPath [ gitMinimal jq nixUnstable ]}
    usr="''${1:-$USER}"

    1>&2 echo "Switching Home Manager configuration for: $usr"

    usrExists="$(nix eval --json .#homeManagerConfigurations --apply 'x: (builtins.any (n: n == "'$usr'") (builtins.attrNames x))' 2>/dev/null)"

    if [ "$usrExists" != "true" ]; then
      1>&2 echo "No configuration found, aborting..."
      exit 1
    fi

    1>&2 echo "Building configuration..."
    out="$(nix build --json ".#homeManagerConfigurations.$usr.activationPackage" | jq -r .[].outputs.out)"
    1>&2 echo "Activating configuration..."
    "$out"/activate
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
