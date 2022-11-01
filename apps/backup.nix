{writeShellApplication}:
writeShellApplication {
  name = "backup";
  text = ''
    TIMESTAMP="$(date +%Y%m%d%H%M%S)"
    BACKUP_DIR="backup/$TIMESTAMP"
    mkdir -p "$BACKUP_DIR/fish" "$BACKUP_DIR/gnupg"
    cp "$HOME"/.local/share/fish/fish_history* "$BACKUP_DIR/fish"
    cp "$HOME"/.gnupg/sshcontrol "$BACKUP_DIR/gnupg"
  '';
}
