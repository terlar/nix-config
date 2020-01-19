{ writeShellScriptBin, systemd }:

writeShellScriptBin "insomnia" ''
  ${systemd}/bin/systemctl --user stop xautolock-session.service
  ${systemd}/bin/systemd-inhibit sleep "$@"
  ${systemd}/bin/systemctl --user start xautolock-session.service
''
