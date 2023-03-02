{
  writeShellApplication,
  # qutebrowser,
}:
writeShellApplication {
  name = "install-qutebrowser-dicts";
  text = ''
    true
  '';
  # text = ''
  #   ${qutebrowser}/share/qutebrowser/scripts/dictcli.py install "$@"
  # '';
}
