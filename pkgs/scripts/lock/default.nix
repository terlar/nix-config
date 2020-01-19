{ writeShellScriptBin, systemd }:

writeShellScriptBin "lock" ''
  exec ${systemd}/bin/loginctl lock-session $XDG_SESSION_ID
''
