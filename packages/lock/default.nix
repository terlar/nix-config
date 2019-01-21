{ writeShellScriptBin, systemd }:

writeShellScriptBin "lock" ''
  ${systemd}/bin/loginctl lock-session $XDG_SESSION_ID
''
