{ writeShellScriptBin, systemd }:

writeShellScriptBin "logout" ''
  ${systemd}/bin/loginctl kill-session $XDG_SESSION_ID
''
