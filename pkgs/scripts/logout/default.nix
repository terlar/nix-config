{
  writeShellScriptBin,
  systemd,
}:
writeShellScriptBin "logout" ''
  exec ${systemd}/bin/loginctl kill-session $XDG_SESSION_ID
''
