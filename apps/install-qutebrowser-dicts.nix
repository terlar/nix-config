{
  writeShellApplication,
  qutebrowser,
}:
writeShellApplication {
  name = "install-qutebrowser-dicts";
  text = ''
    ${qutebrowser}/share/qutebrowser/scripts/dictcli.py install "$@"
  '';
}
