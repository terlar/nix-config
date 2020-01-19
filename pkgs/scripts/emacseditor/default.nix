{ writeShellScriptBin }:

writeShellScriptBin "emacseditor" ''
  if [ -z "$1" ]; then
    exec emacsclient --create-frame --alternate-editor emacs
  else
    exec emacsclient --alternate-editor emacs "$@"
  fi
''
